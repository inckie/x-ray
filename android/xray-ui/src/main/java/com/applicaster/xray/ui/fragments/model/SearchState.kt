package com.applicaster.xray.ui.fragments.model

import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LiveData
import androidx.lifecycle.Observer
import com.applicaster.xray.core.Event

// Don't want to make it observable yet
class SearchState(
    private var list: LiveData<List<Event>>,
    lifecycleOwner: LifecycleOwner
) : Observer<List<Event>> {

    enum class SearchFields(val flag: Int) {
        MESSAGE  (1 shl 0),
        CATEGORY (1 shl 1),
        SUBSYSTEM(1 shl 2),
        CONTEXT  (1 shl 3),
        DATA     (1 shl 4),
        ALL      (MESSAGE.flag or CATEGORY.flag or SUBSYSTEM.flag or CONTEXT.flag or DATA.flag);

        // better than int extension
        fun isSet(mask: Int): Boolean = 0 != flag and mask
    }

    init {
        list.observe(lifecycleOwner, this)
    }

    fun update(text: String) {
        this.text = text
        search()
    }

    private var text = ""
    private var result: List<Event> = emptyList()
    private var current: Int = 0
    private var searchMask = SearchFields.MESSAGE.flag

    fun setMask(mask: Int) {
        searchMask = if(0 != mask) mask else SearchFields.ALL.flag
        search()
    }

    fun getMask() : Int = searchMask

    fun isIn(event: Event): Boolean = result.contains(event)

    fun isCurrent(event: Event): Boolean {
        return result.isNotEmpty() && current < result.size && result[current] == event
    }

    fun getCurrentIndex(): Int? {
        val c = result.getOrNull(current) ?: return null
        return when(val idx = list.value!!.indexOf(c)) {
            -1 -> null
            else -> idx
        }
    }

    fun next(): Boolean = when {
        current + 1 >= result.size -> false
        else -> {
            ++current
            true
        }
    }

    fun prev(): Boolean = when {
        current <= 0 -> false
        else -> {
            --current
            true
        }
    }

    override fun onChanged(t: List<Event>?) = search()

    private fun search() {
        if(text.isEmpty()) {
            result = emptyList()
            current = 0 // can probably use -1
            return
        }
        val c = result.getOrNull(current)
        result = list.value!!.filter { isMatch(it) }.toList()
        current = if(null != c) result.indexOf(c).coerceAtLeast(0) else 0
    }

    private fun isMatch(it: Event): Boolean {
        if (SearchFields.MESSAGE.isSet(searchMask))
            if (it.message.contains(text, ignoreCase = true))
                return true
        if (SearchFields.SUBSYSTEM.isSet(searchMask))
            if (it.subsystem.contains(text, ignoreCase = true))
                return true
        if (SearchFields.CATEGORY.isSet(searchMask))
            if (it.category.contains(text, ignoreCase = true))
                return true
        // simplified
        if (SearchFields.CONTEXT.isSet(searchMask) && null != it.context)
            if (it.context.toString().contains(text, ignoreCase = true))
                return true
        // simplified
        if (SearchFields.DATA.isSet(searchMask) && null != it.data)
            if (it.data.toString().contains(text, ignoreCase = true))
                return true
        return false
    }
}
