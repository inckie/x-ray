package com.applicaster.xray.example.ui

import android.text.format.DateFormat
import android.util.Log
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LiveData
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.RecyclerView
import com.applicaster.xray.core.Event
import com.applicaster.xray.example.databinding.FragmentEventLogBinding

class EventRecyclerViewAdapter(
    owner: LifecycleOwner,
    observableEventList: LiveData<List<Event>>
) : RecyclerView.Adapter<EventRecyclerViewAdapter.ViewHolder>(), Observer<List<Event>> {

    private var values: List<Event> = observableEventList.value!!
    init {
        observableEventList.observe(owner, this)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = FragmentEventLogBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = values[position]
        holder.bind(item)
    }

    override fun getItemCount(): Int = values.size

    inner class ViewHolder(private val binding: FragmentEventLogBinding)
        : RecyclerView.ViewHolder(binding.root) {

        override fun toString(): String {
            return super.toString() + " '" + binding.message.text + "'"
        }

        fun bind(item: Event) {
            binding.tag.text = "${icon(item.level)} ${item.category} ${item.subsystem}"
            binding.message.text = item.message
            binding.time.text = DateFormat.format("yyyy-MM-dd HH:mm:ss", item.timestamp)
        }

        private fun icon(level: Int) : String {
            return when(level) {
                Log.ERROR -> "\uD83D\uDEAB"
                Log.WARN -> "⚠️"
                Log.INFO -> "ℹ️️"
                Log.DEBUG -> "\uD83D\uDC1E️"
                Log.VERBOSE -> "*"
                else -> ""
            }
        }
    }

    override fun onChanged(t: List<Event>?) {
        this.values = t!!
        notifyDataSetChanged()
    }
}