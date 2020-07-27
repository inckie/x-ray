package com.applicaster.xray.example.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.RecyclerView
import com.applicaster.xray.core.Core
import com.applicaster.xray.example.App
import com.applicaster.xray.example.R
import com.applicaster.xray.example.sinks.InMemoryLogSink

/**
 * A fragment representing a list of Items.
 */
class EventLogFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_event_log_list, container, false)

        // We expect our example Application to provide this sink as InMemoryLogSink
        val inMemoryLogSink = Core.get().getSink(App.memory_sink_name) as InMemoryLogSink?

        // Set the adapter
        if (view is RecyclerView && null != inMemoryLogSink) {
            with(view) {
                adapter = EventRecyclerViewAdapter (
                    viewLifecycleOwner,
                    inMemoryLogSink.getLiveData()
                )
            }
        }
        return view
    }

    companion object {

        @JvmStatic
        fun newInstance() = EventLogFragment()
    }
}