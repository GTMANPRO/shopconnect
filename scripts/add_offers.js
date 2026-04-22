const admin = require("firebase-admin");

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

const db = admin.firestore();

// 🔥 Add offers here
const offers = {
  target: "🔥 Up to 25% off home picks",
  walmart: "Save on everyday essentials",
  nike: "Free shipping on select orders",
  amazon: "Top deals updated daily",
};

async function run() {
  const storesRef = db.collection("stores");

  for (const [id, offerText] of Object.entries(offers)) {
    const docRef = storesRef.doc(id);

    await docRef.set(
      {
        offerText,
        offerActive: true,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true }
    );

    console.log(`✅ Updated ${id}`);
  }

  console.log("DONE");
}

run().catch(console.error);
