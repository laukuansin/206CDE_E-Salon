package com.example.gps_tracking_system

import android.annotation.SuppressLint
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.IBinder
import android.util.Log
import android.view.*
import android.widget.ImageView

class ChatHeadService() : Service() {

    lateinit var mWindowManager:WindowManager
    lateinit var mView:View

    @SuppressLint("ClickableViewAccessibility")
    override fun onCreate() {
        super.onCreate()
        mView = LayoutInflater.from(this).inflate(R.layout.chat_head, null)

        var param = WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
        )

        param.gravity = Gravity.TOP or Gravity.LEFT
        param.x = 0
        param.y = 100

        mWindowManager =  getSystemService(Context.WINDOW_SERVICE) as WindowManager
        mWindowManager.addView(mView,param)

        var closeButton = mView.findViewById<ImageView>(R.id.close_btn)
        closeButton.setOnClickListener(View.OnClickListener() {
            stopSelf()
        })

        var chatHeadImage = mView.findViewById<ImageView>(R.id.chat_head_profile_iv)
        chatHeadImage.setOnTouchListener(View.OnTouchListener { view, motionEvent ->
            var lastAction:Int = 0
            var initialX:Int = 0
            var initialY:Int = 0
            var initialTouchX:Float = 0.0f
            var initialTouchY:Float = 0.0f

            when(motionEvent.action){
                MotionEvent.ACTION_DOWN-> {
                    initialX = param.x
                    initialY = param.y
                    initialTouchX = motionEvent.rawX
                    initialTouchY = motionEvent.rawY
                    lastAction = motionEvent.action
                    true
                }
                MotionEvent.ACTION_UP->{
                    if(lastAction == MotionEvent.ACTION_DOWN){
                        var intent = Intent(this, ChatActivity::class.java )
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)

                        stopSelf()
                    }
                    lastAction = motionEvent.action
                    true
                }
                MotionEvent.ACTION_MOVE->{
                    param.x = initialX + (motionEvent.rawX - initialTouchX).toInt()
                    param.y = initialY + (motionEvent.rawY - initialTouchY).toInt()
                    true
                }
                else->false
            }
        })
    }

    override fun onDestroy() {
        super.onDestroy()
        mWindowManager.removeView(mView)
    }

    override fun onBind(p0: Intent?): IBinder? {
        TODO("Not yet implemented")
    }



}