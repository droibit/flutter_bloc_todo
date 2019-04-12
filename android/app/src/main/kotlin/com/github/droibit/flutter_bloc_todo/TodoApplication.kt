package com.github.droibit.flutter_bloc_todo

import com.github.droibit.flutter_bloc_todo.utils.Stetho
import io.flutter.app.FlutterApplication

class TodoApplication : FlutterApplication() {

  override fun onCreate() {
    super.onCreate()
    Stetho.initialize(this)
  }
}