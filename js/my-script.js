
let UserChatID = "";
function scrollTopFun() {
    const scrollableDiv = document.getElementById('scrollableDiv');
    scrollableDiv.scrollTop = scrollableDiv.scrollHeight;
}

// function openlogin() {
//     document.getElementById("loginPage").style.display = "block";
// }

function CountText() {
    var SecountTextLeng = document.getElementById('messagesContainer');
    // Get all h2 elements within the div
    const h2Elements = SecountTextLeng.getElementsByTagName('h2');

    // Get the length of the h2 elements
    const h2Count = h2Elements.length;
    // if (h2Count == 0) {
    //     var TextMessage = '<h2 class="mobile-user-messagetwo"><span class="MobileImageUser"><img width="100%" src="https://policylife.in/wp-content/uploads/2023/09/cropped-fav-icon.png"/></span><span class="mobile-user-span">Vivekananda Health Global has helped thousands to manage their pain. Google rating <b> &#9733&#9733&#9733&#9733&#9733 4.6</b></span></h2>';
    //     var SecoundTxt = document.getElementById('secoundTxtMsg');
    //     SecoundTxt.innerHTML = TextMessage;
    //     var TextMessage2 = '<h2 class="mobile-user-messagetwo"><span class="MobileImageUser"><img width="100%" src="https://policylife.in/wp-content/uploads/2023/09/cropped-fav-icon.png"/></span><span class="mobile-user-span">Please share your <b>Name & Contact</b> details so that our concerned team can connect with you</b></span></h2>';
    //     var SecoundTxt2 = document.getElementById('secoundTxtMsg2');
    //     SecoundTxt2.innerHTML = TextMessage2;
        
    // }
}

function CloseChat() {
    document.getElementById("showchatbody").style.display = "none";
    // document.getElementById("loginPage").style.display = "none";
}
// Get the div element with id "messagesContainer"
function LoginPage() {
    // var introHTML = '<h2 class="mobile-user-message"><span class="mobile-user-span">hi</span></h2>';
    // document.getElementById('messagesContainer').innerHTML = introHTML;
    const uniqueId = `${Date.now()}`;
    console.log(uniqueId);
    // var UerName = document.getElementById("userName").value;
    // var UerPhonenumber = document.getElementById("userPhoneNumber").value;
    UserChatID = "webUser" + uniqueId;
    // if (UerName == "") {
    //     alert("Please Enter Your Details !!!!!");
    // } else {
    document.getElementById("showchatbody").style.display = "block";
    // document.getElementById("loginPage").style.display = "none";
    // }

    // Firebase configuration
    var firebaseConfig = {
        apiKey: "AIzaSyBPC-9B_t-iCibBKlOQslJMwmAyruwkTTk",
        authDomain: "web2app-5336c.firebaseapp.com",
        databaseURL: "https://web2app-5336c-default-rtdb.firebaseio.com",
        projectId: "web2app-5336c",
        storageBucket: "web2app-5336c.appspot.com",
        messagingSenderId: "246080973339",
        appId: "1:246080973339:web:e2a19a6053e615a32be6be",
        measurementId: "G-VPD9B41LTW"
    };

    // Initialize Firebase
    firebase.initializeApp(firebaseConfig);
    const db = firebase.firestore();

    // Function to generate user image URL with first letter of the name
    function generateUserImageURL(name) {
        const firstLetter = name.charAt(0).toUpperCase();
        return `https://ui-avatars.com/api/?name=${firstLetter}&background=random&size=128`;
    }

    function sendNotification(deviceToken, message) 
    {
        var myHeaders = new Headers();
        myHeaders.append("Accept", "application/json");
        myHeaders.append("Authorization", "key=AAAAOUuRqhs:APA91bHiT14Aba-PnBsWqSJreXXtA7q016LkARjECElGde6ar49uiBCN7MUoVi6Z33p1ys4Cqc3Hm8-HpfHspY3uQ79P2S95SESD_6OXyNvl15HoLXX3V1NTzdez_HgquikpYFxd_5Ca");
        myHeaders.append("Content-Type", "application/json");

        var raw = JSON.stringify({
            "notification": {
                "title": "New Message",
                "body": message
            },
            "to": deviceToken
        });

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: raw,
            redirect: 'follow'
        };

        fetch("https://fcm.googleapis.com/fcm/send", requestOptions)
            .then(response => response.text())
            .then(result => console.log(result))
            .catch(error => console.log('error', error));
    }


    // Function to send a message and create a new user document
    function sendMessage() {

        var message = document.getElementById("messageInput").value;
        var userID = UserChatID;
        var name = UserChatID;
        var email = UserChatID + "@example.com";
        var imageURL = generateUserImageURL(name);

        // Check if the user document with the given ID exists
        db.collection("users").doc(userID).get().then((doc) => {
            if (doc.exists) {
                // console.log("User document already exists.");
                // Use the existing user ID and proceed to send the message
                sendChatMessage(userID, message);
            } else {
                // console.log("User document does not exist. Creating a new one.");
                // Create a new user document with the given ID
                db.collection("users").doc(userID).set({
                    name: name,
                    email: email,
                    image: imageURL,
                    uid: userID,
                    date: firebase.firestore.FieldValue.serverTimestamp(),
                    isOnline: true,
                    // Add other user details as needed
                }).then(() => {
                    // console.log("User document created.");
                    // Send the message after creating the user document
                    sendChatMessage(userID, message);
                }).catch((error) => {
                    console.error("Error creating user document:", error);
                });
            }
        }).catch((error) => {
            console.error("Error checking user document:", error);
        });



        // After sending the message, get the device token for the user
        db.collection("userTokens").doc("mageshymd@gmail.com").get().then((doc) => {
            if (doc.exists) {
                const deviceToken = doc.data().token;
                sendNotification(deviceToken, message);
            } else {
                console, log("did't not send the notification");
            }
        }).catch((error) => {
            console.log(error);
        });

    }

    // Function to update the users online status
    function updateUserStatus(userID, isOnline) {
        db.collection("users").doc(userID).update({
            isOnline: isOnline
        }).then(() => {
            // console.log("User online status updated.");
        }).catch((error) => {
            // console.error("Error updating user online status:", error);
        });
    }


    // Add event listener for window focus and blur events
    window.addEventListener("focus", function () {
        // User is active on the website
        updateUserStatus(UserChatID, true);
    });

    window.addEventListener("blur", function () {
        // User has left the website
        updateUserStatus(UserChatID, false);
    });

    // Function to display the users online status
    function displayUserStatus(isOnline) {
        const userStatusContainer = document.getElementById("userStatus");
        userStatusContainer.textContent = isOnline ? "Online" : "Offline";
        var onlinecheckText = document.getElementById("userStatus").innerHTML;
        // console.log(onlinecheckText);
        if (onlinecheckText == "Online") {
            document.getElementById("userStatus").style.color = "green";
        }
        else {
            document.getElementById("userStatus").style.color = "red";
        }
    }


    // Function to listen for changes to the u  sers online status
    function listenForUserStatus(userID) {
        db.collection("users").doc(userID).onSnapshot((doc) => {
            const user = doc.data();
            if (user) {
                displayUserStatus(user.isOnline);
            }
        });
    }

    // Start listening for the users online status when the page loads
    listenForUserStatus(UserChatID);


    // Function to send the chat message
    function sendChatMessage(userID, message) {
        // Add the chat message to the current users collection
        db.collection("users").doc(userID).collection("messages").doc("f0GiIYwIVLSKscuy6w4nymz49vn1").collection("chats").add({
            senderId: userID,
            receiverId: "f0GiIYwIVLSKscuy6w4nymz49vn1",
            message: message,
            type: "text",
            date: firebase.firestore.FieldValue.serverTimestamp(),
            "isRead": false,
        }).then(() => {
            // Message successfully saved to Firestore
            // console.log("Message sent!");

            // Update the last_updated field for the current user
            db.collection("users").doc(userID).collection("messages").doc("f0GiIYwIVLSKscuy6w4nymz49vn1").set({
                "last_msg": message,
                "last_updated": firebase.firestore.FieldValue.serverTimestamp(), // Update the last_updated field with the current timestamp
            }).then(() => {
            }).catch((error) => {
            });

            // Update the last_updated field for the mobile user
            db.collection("users").doc("f0GiIYwIVLSKscuy6w4nymz49vn1").collection("messages").doc(userID).set({
                "last_msg": message,
                "last_updated": firebase.firestore.FieldValue.serverTimestamp(), // Update the last_updated field with the current timestamp
            }).then(() => {
                // console.log("Last message updated for mobile user.");
            }).catch((error) => {
                console.error("Error updating last message for mobile user:", error);
            });
        }).catch((error) => {
            // Error saving message to Firestore
            console.error("Error sending message:", error);
        });

        // Add the chat message to the mobile users collection
        db.collection("users").doc("f0GiIYwIVLSKscuy6w4nymz49vn1").collection("messages").doc(userID).collection("chats").add({
            senderId: userID,
            receiverId: "f0GiIYwIVLSKscuy6w4nymz49vn1",
            message: message,
            type: "text",
            date: firebase.firestore.FieldValue.serverTimestamp(),
            "isRead": false,
        }).then(() => {
            // Message successfully saved to Firestore
            // console.log("Message sent!");

            // Update the last_updated field for the mobile user
            db.collection("users").doc("f0GiIYwIVLSKscuy6w4nymz49vn1").collection("messages").doc(userID).set({
                "last_msg": message,
                "last_updated": firebase.firestore.FieldValue.serverTimestamp(), // Update the last_updated field with the current timestamp
            }).then(() => {
                // console.log("Last message updated for current user.");
            }).catch((error) => {
                console.error("Error updating last message for current user:", error);
            });

            // Update the last_updated field for the current user
            db.collection("users").doc(userID).collection("messages").doc("f0GiIYwIVLSKscuy6w4nymz49vn1").set({
                "last_msg": message,
                "last_updated": firebase.firestore.FieldValue.serverTimestamp(), // Update the last_updated field with the current timestamp
            }).then(() => {
                // console.log("Last message updated for mobile user.");
            }).catch((error) => {
                console.error("Error updating last message for mobile user:", error);
            });
        }).catch((error) => {
            console.error("Error sending message:", error);
        });
    }
    // Function to display messages sent by the mobile user
    function displayMessages(messages) {
        // console.log(messages);
        // document.getElementById("messageInput").value = "";
        var SecountTextLengLength = messages.length;
        if (SecountTextLengLength == 1) {
            const messagesContainer = document.getElementById("messagesContainer1");
            messagesContainer.innerHTML = "";
            messages.forEach((message) => {
                const div = document.createElement("h2");
                const span = document.createElement("span");
                // const divIntrotext = document.createElement("div");
                // divIntrotext.id="secoundTxtMsg";
                span.textContent = message.message;
                const spanImage = document.createElement("span");
                const ImageMobileUser = document.createElement("img");
                var MessageLength = message.message.length;
                if (MessageLength > 22) {
                    if (message.senderId === "f0GiIYwIVLSKscuy6w4nymz49vn1") {
                        // Add a CSS class for messages sent by the mobile user
                        div.classList.add("mobile-user-messagetwo");
                        span.classList.add("mobile-user-span");
                        // span1.classList.add("TimeText");
                        spanImage.classList.add("MobileImageUser");
                        ImageMobileUser.src = "https://policylife.in/wp-content/uploads/2023/09/cropped-fav-icon.png";
                        ImageMobileUser.width = 100;
                        div.appendChild(spanImage);
                        spanImage.appendChild(ImageMobileUser);
                    } else {
                        // Add a CSS class for messages sent by the web user
                        div.classList.add("web-user-messagetwo");
                        span.classList.add("web-user-span");
                    }
                    document.getElementById("messageInput").value = "";
                    messagesContainer.appendChild(div);
                    div.appendChild(span);
                    // div.appendChild(divIntrotext);                               
                }
                else if (MessageLength < 22) {
                    if (message.senderId === "f0GiIYwIVLSKscuy6w4nymz49vn1") {
                        // Add a CSS class for messages sent by the mobile user
                        div.classList.add("mobile-user-message");
                        span.classList.add("mobile-user-span");
                        // span1.classList.add("TimeText");
                        spanImage.classList.add("MobileImageUser");
                        ImageMobileUser.src = "https://policylife.in/wp-content/uploads/2023/09/cropped-fav-icon.png";
                        ImageMobileUser.width = 100;
                        div.appendChild(spanImage);
                        spanImage.appendChild(ImageMobileUser);
                    } else {
                        // Add a CSS class for messages sent by the web user
                        div.classList.add("web-user-message");
                        span.classList.add("web-user-span");
                    }
                    document.getElementById("messageInput").value = "";
                    messagesContainer.appendChild(div);
                    div.appendChild(span);
                    // div.appendChild(divIntrotext);
                    // div.appendChild(span1);
                }
            });
            CountText()
            scrollTopFun()
        }
        else {
            const messagesContainer = document.getElementById("messagesContainer");
            messagesContainer.innerHTML = "";
            console.log(messages);
            messages.slice(1).forEach((message) => {
                const div = document.createElement("h2");
                const span = document.createElement("span");
                // const divIntrotext = document.createElement("div");
                // divIntrotext.id="secoundTxtMsg";
                span.textContent = message.message;
                const spanImage = document.createElement("span");
                const ImageMobileUser = document.createElement("img");
                var MessageLength = message.message.length;
                if (MessageLength > 30) {
                    if (message.senderId === "f0GiIYwIVLSKscuy6w4nymz49vn1") {
                        // Add a CSS class for messages sent by the mobile user
                        div.classList.add("mobile-user-messagetwo");
                        span.classList.add("mobile-user-span");
                        // span1.classList.add("TimeText");
                        spanImage.classList.add("MobileImageUser");
                        ImageMobileUser.src = "https://policylife.in/wp-content/uploads/2023/09/cropped-fav-icon.png";
                        ImageMobileUser.width = 100;
                        div.appendChild(spanImage);
                        spanImage.appendChild(ImageMobileUser);
                    } else {
                        // Add a CSS class for messages sent by the web user
                        div.classList.add("web-user-messagetwo");
                        span.classList.add("web-user-span");
                    }
                    document.getElementById("messageInput").value = "";
                    messagesContainer.appendChild(div);
                    div.appendChild(span);
                    // div.appendChild(divIntrotext);                               
                }
                else if (MessageLength < 30) {
                    if (message.senderId === "f0GiIYwIVLSKscuy6w4nymz49vn1") {
                        // Add a CSS class for messages sent by the mobile user
                        div.classList.add("mobile-user-message");
                        span.classList.add("mobile-user-span");
                        // span1.classList.add("TimeText");
                        spanImage.classList.add("MobileImageUser");
                        ImageMobileUser.src = "https://policylife.in/wp-content/uploads/2023/09/cropped-fav-icon.png";
                        ImageMobileUser.width = 100;
                        div.appendChild(spanImage);
                        spanImage.appendChild(ImageMobileUser);
                    } else {
                        // Add a CSS class for messages sent by the web user
                        div.classList.add("web-user-message");
                        span.classList.add("web-user-span");
                    }
                    document.getElementById("messageInput").value = "";
                    messagesContainer.appendChild(div);
                    div.appendChild(span);
                    // div.appendChild(divIntrotext);
                    // div.appendChild(span1);
                }
            });
            scrollTopFun()
        }

    }
    // Function to listen for new messages in Firestore
    function listenForMessages(userID) {
        db.collection("users").doc(userID).collection("messages").doc("f0GiIYwIVLSKscuy6w4nymz49vn1").collection("chats")
            .orderBy("date")
            .onSnapshot((querySnapshot) => {
                const messages = [];
                querySnapshot.forEach((doc) => {
                    messages.push(doc.data());
                });
                displayMessages(messages);
            });

        // Add another listener for messages sent by the web user with the given userID
        db.collection("users").doc("f0GiIYwIVLSKscuy6w4nymz49vn1").collection("messages").doc(userID).collection("chats")
            .orderBy("date")
            .onSnapshot((querySnapshot) => {
                const messages = [];
                querySnapshot.forEach((doc) => {
                    messages.push(doc.data());
                });
                displayMessages(messages);
            });
    }



    // Add event listener to the "Submit" button
    document.getElementById("submitButton").addEventListener("click", function () {
        sendMessage();
        // After sending the message, start listening for new messages
        listenForMessages(UserChatID);
    });
    var input = document.getElementById("messageInput");
    input.addEventListener("keypress", function (event) {
        if (event.key === "Enter") {
            event.preventDefault();
            sendMessage();
            // CountText()
            // After sending the message, start listening for new messages
            listenForMessages(UserChatID);
        }
    });

    // Start listening for messages when the page loads
    listenForMessages(UserChatID);
}
////////////////////////Admin Data show wordpress 
