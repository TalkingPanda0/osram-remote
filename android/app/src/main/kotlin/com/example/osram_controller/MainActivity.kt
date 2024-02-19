package org.talkingpanda.osram_remote

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.hardware.ConsumerIrManager
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.reflect.typeOf


class MainActivity: FlutterActivity() {
    private val CHANNEL = "org.talkingpanda/irtransmitter"
    private var irManager: ConsumerIrManager? = null
    private fun convertIntegers(integers: List<Int>): IntArray? {
        val ret = IntArray(integers.size)
        val iterator = integers.iterator()
        for (i in ret.indices) {
            ret[i] = iterator.next()
        }
        return ret
    }
    @RequiresApi(VERSION_CODES.O)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        irManager = getSystemService(Context.CONSUMER_IR_SERVICE) as? ConsumerIrManager;
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "transmit") {
                val list = call.argument<ArrayList<Int>>("list")
                if(irManager == null){
                    result.success(null);
                } else if(list == null) {
                    result.error( "NOPATTERN","No pattern given",null)
                } else {
                    irManager?.transmit(38028,list.toIntArray());
                }
                result.success(null);
            } else if(call.method == "hasIrEmitter"){
                if(irManager == null){
                    result.success(false);
                    
                } else {
                    result.success(irManager?.hasIrEmitter());
                }
                
            } else 
                result.notImplemented()
                }
            }
        }

