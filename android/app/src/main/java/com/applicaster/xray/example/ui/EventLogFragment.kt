package com.applicaster.xray.example.ui

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.RecyclerView
import com.applicaster.xray.core.Core
import com.applicaster.xray.example.R
import com.applicaster.xray.example.sinks.InMemoryLogSink

/**
 * A fragment representing a list of Items.
 */
class EventLogFragment : Fragment() {

    private val sink = InMemoryLogSink()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_event_log_list, container, false)

        // Set the adapter
        if (view is RecyclerView) {
            with(view) {
                adapter = EventRecyclerViewAdapter(
                    viewLifecycleOwner,
                    sink.getLiveData()
                )
            }
        }
        return view
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        Core.get().addSink("ui_log", sink)
    }

    override fun onDetach() {
        Core.get().removeSink(sink)
        super.onDetach()
    }

    companion object {

        @JvmStatic
        fun newInstance() = EventLogFragment()
    }
}