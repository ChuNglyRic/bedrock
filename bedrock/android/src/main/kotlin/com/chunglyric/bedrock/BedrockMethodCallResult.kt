package com.chunglyric.bedrock

data class BedrockMethodCallResult(
    val succeed: Boolean,
    val result: Any? = null,
    val errorMessage: String? = null
)
