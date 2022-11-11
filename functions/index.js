const functions = require("firebase-functions");
const admin = require('firebase-admin');
const {DateTime, Duration} = require("luxon");

admin.initializeApp();
const db = admin.firestore().collection('/employees');
console.log(admin.firestore.timeStamp.now());
// exports.schedule = functions.pubsub.schedule('58 2 * * *').timeZone('Africa/Cairo').onRun(async (context) => {
//         const documents = await db.get();
//         documents.forEach((result) => {
//
//                 if (result.data().employeeState === "خارج ساعات العمل") {
//
//                     result.ref.update({'employeeState': 'غائب'});
//                 }
//
//             }
//         );
//
//     }
// );

exports.registerAsAbsent = functions.pubsub.schedule('* * * 5 *').timeZone('Africa/Cairo').onRun(async (context) => {
        const documents = await db.get();
        documents.forEach((result) => {
                if (result.data().employeeState === 'خارج ساعات العمل') {
                    let workingFrom = result.data().workingFrom;
                    let allowedDelay = result.data().workingTo;

                    let nowTime = DateTime.now();
                    let workingFromTime = DateTime.fromFormat(workingFrom, 'H:m');
                    let totalTime = workingFromTime.plus(Duration.fromISOTime(allowedDelay));

                    if (Duration.fromISOTime(workingFrom).plus(Duration.fromISOTime(allowedDelay)).as('hour') >= 24) {
                        if (nowTime.get('day') < totalTime.get('day')) {
                            totalTime = totalTime.set({day: totalTime.get('day') - 1});
                        }
                    }
                    if (totalTime.diffNow().toMillis() < 0) {
                        result.ref.update({
                            'employeeState': 'غائب',
                            'absenceDays': result.data().absenceDays + 1,
                            'wasEmployeeAbsent': true,
                            'absenceDay': admin.firestore.Timestamp.now(),
                            'outsideWorkingHours': true,
                        })
                    }
                }
            }
        )


    }
)

