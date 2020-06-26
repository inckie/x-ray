package com.applicaster.xray.example.ui

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LiveData
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.RecyclerView
import com.applicaster.xray.Event
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
            binding.tag.text = item.tag
            binding.message.text = item.message
        }
    }

    override fun onChanged(t: List<Event>?) {
        this.values = t!!
        notifyDataSetChanged()
    }
}