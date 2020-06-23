package com.applicaster.xray.formatting.message

class BasicMessageFormatter :
    IMessageFormatter {
    override fun format(template: String, outParameters: MutableMap<String, Any>?, vararg args: Any?): String {
        return String.format(template, *args)
    }
}