package com.example.gps_tracking_system

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "gps_tracking_system/firebase"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
             if(call.method == "firebaseAutoLocationUpdateService"){
                val workerId = call.argument<String>("worker_id")
                val appointmentId = call.argument<String>("appointment_id");
                startFirebaseAutoLocationUpdateService(workerId as String, appointmentId as String)
            } else if(call.method == "stopFirebaseAutoLocationUpdateService"){
                 stopFirebaseAutoLocationUpdateService()
             }
        }

    }

    private fun startFirebaseAutoLocationUpdateService(workerId:String, appointmentId: String){
        val intent = Intent(context, FirebaseService::class.java)
        val bundle = Bundle()
        bundle.putString("worker_id", workerId)
        bundle.putString("appointment_id", appointmentId)
        intent.putExtra("firebaseWorkerId", bundle)
        startService(intent)
    }

    private fun stopFirebaseAutoLocationUpdateService(){
        val intent = Intent(context, FirebaseService::class.java)
        stopService(intent);
    }
}
