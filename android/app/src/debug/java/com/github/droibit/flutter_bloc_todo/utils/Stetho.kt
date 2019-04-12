package com.github.droibit.flutter_bloc_todo.utils

import com.facebook.stetho.Stetho as ActualStehto
import android.content.Context

object Stetho {

  fun initialize(context: Context) {
    ActualStehto.initializeWithDefaults(context)
  }
}