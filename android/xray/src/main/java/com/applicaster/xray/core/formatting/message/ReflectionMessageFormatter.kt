package com.applicaster.xray.core.formatting.message

import com.squareup.moshi.Moshi
import com.squareup.moshi.kotlin.reflect.KotlinJsonAdapterFactory

/*
 High cost object unpacking adapter
 */
open class ReflectionMessageFormatter : IMessageFormatter {

    private val moshi: Moshi = Moshi.Builder()
        .add(KotlinJsonAdapterFactory())
        .build()

    override fun format(template: String, outParameters: MutableMap<String, Any?>?, vararg args: Any?): String {
        val plainArgs = args.map {
            when (it) {
                null -> "null"
                else ->
                    when (it) {
                        is String -> it
                        is Number -> it.toString()
                        is Boolean -> it.toString()
                        else -> deserialize(it)
                    }
            }
        }.toTypedArray()
        return String.format(template, *plainArgs)
    }

    private fun deserialize(it: Any): String {
        val adapter = moshi.adapter(it.javaClass)
        // todo: keep type adapters cache
        return adapter.toJson(it)!!
    }
}
