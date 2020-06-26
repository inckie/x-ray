package com.applicaster.xray.example.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.applicaster.xray.Core
import com.applicaster.xray.example.EventRecyclerViewAdapter
import com.applicaster.xray.example.R
import com.applicaster.xray.example.UILogSink

/**
 * A fragment representing a list of Items.
 */
class EventLogFragment : Fragment() {

    private lateinit var sink: UILogSink
    private var columnCount = 1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        arguments?.let {
            columnCount = it.getInt(ARG_COLUMN_COUNT)
        }
        sink = UILogSink() // should be persistent shared object, if we want to see all log events
        Core.get().addSink("ui_log", sink)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_event_log_list, container, false)

        // Set the adapter
        if (view is RecyclerView) {
            with(view) {
                layoutManager = when {
                    columnCount <= 1 -> LinearLayoutManager(context)
                    else -> GridLayoutManager(context, columnCount)
                }
                adapter = EventRecyclerViewAdapter(viewLifecycleOwner, sink.getLiveData())
            }
        }
        return view
    }

    override fun onDetach() {
        super.onDetach()
        Core.get().removeSink(sink)
    }

    companion object {

        // TODO: Customize parameter argument names
        const val ARG_COLUMN_COUNT = "column-count"

        // TODO: Customize parameter initialization
        @JvmStatic
        fun newInstance(columnCount: Int) =
            EventLogFragment().apply {
                arguments = Bundle().apply {
                    putInt(ARG_COLUMN_COUNT, columnCount)
                }
            }
    }
}