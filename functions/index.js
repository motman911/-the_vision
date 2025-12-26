const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const { setGlobalOptions } = require("firebase-functions/v2");

admin.initializeApp();

// إعدادات المنطقة (اختياري، نتركه افتراضي)
setGlobalOptions({ maxInstances: 10 });

exports.sendOrderStatusNotification = onDocumentUpdated("equivalence_requests/{requestId}", async (event) => {
    // في الإصدار الجديد، البيانات تأتي داخل event.data
    if (!event.data) {
        return;
    }

    const newValue = event.data.after.data();
    const previousValue = event.data.before.data();

    // التحقق من وجود تغيير فعلي في الحالة
    if (newValue.status === previousValue.status && 
        newValue.rejectionReason === previousValue.rejectionReason &&
        newValue.finalEquivalenceUrl === previousValue.finalEquivalenceUrl) {
        return null;
    }

    const userId = newValue.userId;
    const studentName = newValue.studentName || 'الطالب';

    console.log(`تغيرت حالة الطلب للطالب: ${studentName} (ID: ${userId})`);

    // جلب توكن الجهاز
    const userDoc = await admin.firestore().collection('users').doc(userId).get();
    
    if (!userDoc.exists || !userDoc.data().fcmToken) {
        console.log('لا يوجد توكن (FCM Token) للمستخدم');
        return null;
    }

    const fcmToken = userDoc.data().fcmToken;

    // تجهيز نص الرسالة
    let title = "تحديث في طلبك 🔔";
    let body = "تم تحديث حالة طلب المعادلة.";

    if (newValue.status === 2) {
        title = "طلبك قيد المراجعة ⚙️";
        body = `مرحباً ${studentName}، بدأنا في مراجعة مستنداتك.`;
    } else if (newValue.status === 3) {
        title = "مبارك! اكتمل طلبك ✅";
        body = "تم الانتهاء من المعادلة ورفع الشهادة. ادخل التطبيق لتحميلها.";
    } else if (newValue.status === 0) {
        title = "تنبيه بخصوص طلبك ⚠️";
        body = `عذراً، يوجد ملاحظات: ${newValue.rejectionReason || 'راجع التطبيق للتفاصيل'}`;
    }

    // إرسال الإشعار
    const message = {
        notification: {
            title: title,
            body: body,
        },
        token: fcmToken,
        data: {
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
            type: 'order_update',
            orderId: event.params.requestId
        }
    };

    try {
        await admin.messaging().send(message);
        console.log('تم إرسال الإشعار بنجاح ✅');
    } catch (error) {
        console.error('فشل إرسال الإشعار:', error);
    }
});