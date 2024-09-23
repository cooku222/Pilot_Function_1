package com.example.route

import android.os.Bundle
import com.skt.Tmap.TMapView  // TMapView import
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel  // MethodChannel import

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.route/native"  // Flutter와 동일한 채널 이름 사용

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // MethodChannel 초기화
        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "initTmap") {
                // TMap API 초기화 로직
                val tMapView = TMapView(this)
                tMapView.setSKTMapApiKey("EhDYONMDB86WyuLiJIzIo4kVcx8Ptd6c7g6SyONR")// TMap API 키 설정

                result.success("TMap initialized")  // 성공 시 메시지 반환
            } else {
                result.notImplemented()  // 다른 메소드 호출이 있을 경우 처리하지 않음
            }
        }
    }
}
