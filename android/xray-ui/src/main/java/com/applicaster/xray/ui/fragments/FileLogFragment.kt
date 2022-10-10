package com.applicaster.xray.ui.fragments

import android.content.Context
import android.os.Bundle
import android.os.FileObserver
import android.text.TextUtils
import android.text.format.Formatter
import android.util.AttributeSet
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.Fragment
import androidx.lifecycle.Lifecycle
import com.applicaster.xray.crashreporter.Reporting
import com.applicaster.xray.ui.R
import com.applicaster.xray.ui.utility.SharedFileHelper.copyToDownloads
import java.io.File
import java.util.*

class FileLogFragment : Fragment() {

    private var fileName: String? = null
    private var file: File? = null
    private var observer: FileObserver? = null

    private var lblLigSize: TextView? = null
    private var logView: TextView? = null
    private var btnClear: ImageButton? = null
    private var btnSend: ImageButton? = null

    private val updater: Runnable = Runnable { reloadLog() }
    private lateinit var fileCreateListener: Runnable

    init {
        fileCreateListener = Runnable {
            logView?.removeCallbacks(fileCreateListener)
            if(!lifecycle.currentState.isAtLeast(Lifecycle.State.RESUMED)) {
                return@Runnable
            }
            if(null == file) {
                logView?.postDelayed(fileCreateListener, CREATE_SCAN_INTERVAL)
                return@Runnable
            }
            if(file!!.exists()) {
                reloadLog()
            } else {
                logView?.postDelayed(fileCreateListener, CREATE_SCAN_INTERVAL)
            }
        }
    }

    override fun onInflate(context: Context, attrs: AttributeSet, savedInstanceState: Bundle?) {
        super.onInflate(context, attrs, savedInstanceState)
        val ta = context.obtainStyledAttributes(attrs, R.styleable.FileLogFragment_MembersInjector)
        if (ta.hasValue(R.styleable.FileLogFragment_MembersInjector_file_name)) {
            fileName = ta.getString(R.styleable.FileLogFragment_MembersInjector_file_name)
        }
        ta.recycle()
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.xray_fragment_log, container, false)

        arguments?.let {
            // override value from xml
            fileName = it.getString(ARG_FILE_NAME, fileName)
        }

        file = if (TextUtils.isEmpty(fileName)) null else requireActivity().getFileStreamPath(fileName)
        logView = view.findViewById(R.id.lbl_log)
        btnSend = view.findViewById(R.id.btn_send)
        btnSend?.setOnClickListener { send() }
        btnClear = view.findViewById(R.id.btn_clear)
        btnClear?.setOnClickListener { clear() }
        lblLigSize = view.findViewById(R.id.lbl_log_size)
        lblLigSize?.setOnClickListener { reloadLog(true) }
        if(null != file) {
            view.setTag(R.id.fragment_title_tag, file!!.name)
        }
        return view
    }

    private fun reloadLog(forceLoad: Boolean = false) {
        if(!lifecycle.currentState.isAtLeast(Lifecycle.State.RESUMED)) {
            return
        }
        if (null == logView) {
            return
        }
        var hasLog = false
        if (null == file) {
            logView?.text = MSG_FILE_NOT_SPECIFIED
            lblLigSize?.text = ""
        } else if (!file!!.exists()) {
            logView?.text = MSG_NOT_FOUND
            lblLigSize?.text = ""
            logView?.postDelayed(fileCreateListener, CREATE_SCAN_INTERVAL)
        } else {
            val fileSize = Formatter.formatFileSize(lblLigSize!!.context, file!!.length())
            if(forceLoad || file!!.length() < SIZE_LIMIT) {
                lblLigSize!!.text = fileSize
                val log = file!!.readText(Charsets.UTF_8)
                hasLog = !TextUtils.isEmpty(log)
                logView?.text = if (hasLog) log else MSG_EMPTY
            } else {
                hasLog = true
                // do not update log text view
                lblLigSize!!.text = "$fileSize.\nLog is too big, tap here to load."
                if(TextUtils.isEmpty(logView?.text)) {
                    logView?.text = "Log file is bigger than ${Formatter.formatFileSize(lblLigSize!!.context, SIZE_LIMIT)}.\nAuto load disabled."
                }
            }
            lblLigSize!!.setTextColor(lblLigSize!!.resources.getColor(
                if(file!!.length() < SIZE_LIMIT) android.R.color.black
                else android.R.color.holo_red_dark))
            startFileObserver() // can be called multiple times, no problem
        }
        btnSend?.isEnabled = hasLog
        btnClear?.isEnabled = hasLog
    }

    private fun startFileObserver() {
        if (null != file) {
            @Suppress("DEPRECATION")
            observer = object : FileObserver(file?.absolutePath, CLOSE_WRITE or DELETE_SELF) {
                override fun onEvent(event: Int, path: String?) {
                    // do not let update too often, it degrade performance to a point of unusable
                    logView?.removeCallbacks(updater)
                    logView?.postDelayed(updater, UPDATE_DELAY)
                    if(event == DELETE_SELF) {
                        // file descriptor will be new, this observer will not work anymore
                        observer = null
                    }
                }
            }
            observer?.startWatching()
        }
    }

    override fun onPause() {
        super.onPause()
        observer?.stopWatching()
        logView?.removeCallbacks(updater)
        logView?.removeCallbacks(fileCreateListener)
    }

    override fun onResume() {
        super.onResume()
        logView?.post(updater)
    }

    private fun send() {
        if (true != file?.exists()) return

        val items = arrayOf(
            requireView().resources.getString(R.string.xray_btn_share_target_file),
            requireView().resources.getString(R.string.xray_btn_share_target_intent)
        )

        AlertDialog.Builder(logView!!.context)
            .setTitle(getString(R.string.xray_dlg_title_share_events))
            .setNegativeButton(android.R.string.cancel, null)
            .setSingleChoiceItems(items, -1) { d, which ->
                when (which) {
                    1 -> Reporting.sendLogReport(requireActivity(), file)
                    else -> copyLogFile(requireActivity(), file!!)
                }
                d.dismiss()
            }
            .show()
    }

    private fun copyLogFile(context: Context, file: File) {
        try {
            copyToDownloads(
                context,
                file,
                "${file.nameWithoutExtension}_${Date().time}.${file.extension}",
                "text/*"
            ).let {
                Toast.makeText(context, "Log was saved to $it", Toast.LENGTH_LONG).show()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error during copy", e)
            Toast.makeText(context, "Error during copy ${e.message}", Toast.LENGTH_LONG)
                .show()
        }
    }

    private fun clear() {
        // it should trigger file observer, but for clarity we set it here, too
        if (true == file?.delete()) {
            logView!!.text = MSG_NOT_FOUND
            btnSend?.isEnabled = false
            btnClear?.isEnabled = false
        }
    }

    companion object {
        @JvmStatic
        fun newInstance() = FileLogFragment()

        @JvmStatic
        fun newInstance(fileName: String) = FileLogFragment().apply {
            arguments = Bundle().apply {
                putString(ARG_FILE_NAME, fileName)
            }
        }

        private const val ARG_FILE_NAME: String = "file_name"

        private const val UPDATE_DELAY = 100L
        private const val CREATE_SCAN_INTERVAL = 500L
        private const val MSG_EMPTY = "[Empty]"
        private const val MSG_NOT_FOUND = "[Not found]"
        private const val MSG_FILE_NOT_SPECIFIED = "[File not specified]"

        // max size that we will attempt to load automatically
        private const val SIZE_LIMIT = 100 * 1024L

        private const val TAG: String = "FileLogFragment"
    }
}
