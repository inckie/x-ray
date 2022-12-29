package com.applicaster.xray.ui.fragments.model

import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Observer
import com.applicaster.xray.core.Event
import com.applicaster.xray.core.LogLevel

class FilteredEventList(
    owner: LifecycleOwner,
    private val originalList: LiveData<List<Event>>,
    state: FilteredListState? = null
) : MutableLiveData<List<Event>>(), Observer<List<Event>> {

    data class Filter(
        var subsystem: String = "",
        var category: String = "",
        var level: LogLevel = LogLevel.verbose
    ) {
        fun filter(event: Event): Boolean = event.level >= level.level
                && (subsystem.isBlank() or event.subsystem.contains(subsystem, true))
                && (category.isBlank() or event.category.contains(category, true))
    }

    data class FilteredListState(
        val filter: Filter = Filter(),
        var skip: Int = 0
    )

    private val state = state ?: FilteredListState()

    var subsystem: String
        set(value) {
            state.filter.subsystem = value
            update()
        }
        get() = state.filter.subsystem

    var category: String
        set(value) {
            state.filter.category = value
            update()
        }
        get() = state.filter.category

    var level: LogLevel
        set(value) {
            state.filter.level = value
            update()
        }
        get() = state.filter.level

    var skip: Int
        set(value) {
            state.skip = value
            update()
        }
        get() = state.skip

    fun hideCurrent() {
        skip = originalList.value!!.size
    }

    private fun update() {
        // Assuming we are in the main thread
        value = originalList.value!!.drop(skip).filter { state.filter.filter(it) }
    }

    init {
        update()
        this.originalList.observe(owner, this)
    }

    override fun onChanged(t: List<Event>?) = update()
}
