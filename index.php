<?php
/*
Plugin Name: Chat To Web
Description: A custom shortcode for displaying a message[WebtoChat].
Version: 1.0
Author: Muthaiah K 
*/

// Shortcode function
function custom_shortcode_function() 
{
    wp_enqueue_script('my-custom-script', plugin_dir_url(__FILE__) . 'js/my-script.js', array('jquery'), '1.0', true);
    return '<!DOCTYPE html>
    <html lang="en">
    
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chat App</title>
        <!-- Add the Firebase script -->
        <script src="https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js"></script>
        <script src="https://www.gstatic.com/firebasejs/8.10.0/firebase-firestore.js"></script>
        <style>
            @import url("https://fonts.googleapis.com/css2?family=Poppins:wght@500&display=swap");
            .chatbody {
                display: none;
            }
    
            .iconimage { 
                position: fixed;
                right: 19px !important;
                bottom: 4.5rem !important;
                box-shadow: rgba(100, 100, 111, 0.2) 0px 7px 29px 0px !important;
                background: white !important;
                border-radius: 4px !important;
                z-index: 999 !important;
                padding: 2px;
                font-family: "Poppins", sans-serif !important;
                border-radius: 21% !important;
            }
    
            .loginPage {
                display: none;
                background: whitesmoke !important;
                width: 25% !important;
                text-align: center !important;
                padding-bottom: 1rem !important;
                padding-top: 0px !important;
                position: fixed !important;
                right: 16px !important;
                bottom: 15px !important;
                border-radius: 20px !important;
                z-index: 999 !important;
                overflow: hidden !important;
                font-family: "Poppins", sans-serif !important;
            }
    
          
            .LiveChatText_1 {
                font-size:18px !important;
                font-family: "Poppins", sans-serif !important;
                text-align: center !important;
                background: black !important;
                color: white !important;
                border-radius: 15px 15px 0px 0px !important;
            }
    
            .userNametxt {
                font-family: "Poppins", sans-serif !important;
                text-align: left !important;
                padding-left: 5px !important;
                padding-bottom: 10px !important;
                font-size: 18px !important;
            }
    
            .usernameinput {
                font-family: "Poppins", sans-serif !important;
                border: 0.5px gray !important;
                width: 90% !important;
                padding: 8px !important;
                margin-bottom: 11px !important;
                border-radius: 6px !important;
                box-shadow: rgba(100, 100, 111, 0.2) 0px 7px 29px 0px !important;
                border: none !important;
                border-bottom: 1px solid gray !important;
                margin-bottom: 30px !important;
                /* padding-bottom: 10px; */
            }
    
            .startBtn {
                font-family: "Poppins", sans-serif !important;
                width: 60% !important;
                padding: 12px !important;
                border: none !important;
                border-radius: 10px !important;
                background: green !important;
                color: white !important;
                font-size: 16px !important;
                margin-top: 19px !important;
                margin-bottom: 20px !important;
            }
    
            .MainChatBody {
                font-family: "Poppins", sans-serif !important;
                background: whitesmoke !important;
                width: 25% !important;
                border-radius: 20px !important;
                position: fixed ;
                right: 12px !important;
                bottom: 9px !important;
                display: none ;
                z-index: 999 !important;
                overflow: hidden !important;
            }
    
            .messagesbody {
                font-family: "Poppins", sans-serif !important;
                height: 14rem !important;
                padding: 20px !important;
                overflow: hidden !important;
                overflow-y: auto !important;
                background: white !important;
                margin-left: 13px !important;
                margin-right: 17px !important;
                border-radius: 6px !important;
                margin-top: 10px !important;
                padding-left: 0px !important;
                padding-right: 0px !important;
            }
    
            .input {
                font-family: "Poppins", sans-serif !important;
                background: white !important;
                margin: 15px !important;
                border-radius: 7px !important;
            }
            .closebtn
            {
                font-family: "Poppins", sans-serif !important;
                margin-top:10px;
                margin-left: 25px;

            }
    
            .chatinputfiled {
                font-family: "Poppins", sans-serif !important;
                width: 66% !important;
                padding: 12px !important;
                border: none !important;
                margin-bottom: 0px !important;
                margin-right: 50px !important;
            }
    
            #submitButton {
                font-family: "Poppins", sans-serif !important;
                background: transparent !important;
                width: 15% !important;
                border: none !important;
            }
    
            .sendBtnChat {
                font-family: "Poppins", sans-serif !important;
                margin: -8px !important;
                max-width: fit-content !important;
                width: 77%;
            }
    
            /* .web-user-message {
                text-align: end !important;
                padding: 10px !important;
            } */
    
            /* .mobile-user-span {
                background: antiquewhite !important;
                padding: 5px !important;
                padding-left: 19px !important;
                padding-right: 20px !important;
                border-radius: 5px !important;
            } */
    
            /* .web-user-span {
                background: antiquewhite !important;
                padding: 5px !important;
                padding-left: 19px !important;
                padding-right: 20px !important;
                border-radius: 5px !important;
            } */
    
          
    
            .UserName,
            :after,
            :before {
                font-family: "Poppins", sans-serif !important;
                box-sizing: content-box !important;
            }
    
            #userStatus {
                font-family: "Poppins", sans-serif !important;
                font-size: 14px !important;
            }
    
            .col-md-2 {
                font-family: "Poppins", sans-serif !important;
                width: 20% !important;
            }
    
            .col-md-4 {
                font-family: "Poppins", sans-serif !important;
                width: 60% !important;
            }
    
            .row1 {
                font-family: "Poppins", sans-serif !important;
                display: flex;
                flex-wrap: wrap !important;
                width: 100% !important;
            }
    
    
            .mycontainer {
                font-family: "Poppins", sans-serif !important;
                width: 100% !important;
                background: black !important;
                border-radius: 10px 10px 0px 0px !important;
                // padding: 10px !important;
                padding-top:15px !important;
                padding-bottom:15px !important;
            }
    
            .LoginmainDiv {
                font-family: "Poppins", sans-serif !important;
                padding: 15px !important;
            }
            .web-user-span
            {
                font-family: "Poppins", sans-serif !important;
                color: black !important;
                /* padding: 18px !important; */
                background: #e1e9f9 !important;
                padding-left: 10px !important;
                padding-right: 10px !important;
                margin-right: 6px !important;
                border-radius: 10px 0px 10px 0px !important;
                font-size: 13px !important;
                padding: 13px !important;
                font-weight: 500 !important;
                margin-left: 38px !important;
            }
            .mobile-user-span
            {
                font-family: "Poppins", sans-serif !important;
                color: black !important;
                /* padding: 18px; */
                background: #e1e9f9 !important;
                padding-left: 10px !important;
                padding-right: 10px !important;
                margin-right: 29px !important;
                border-radius: 10px 0px 10px 0px !important;
                font-size: 13px !important;
                padding: 13px !important;
                font-weight: 500 !important;
                width: 80% !important;
                word-wrap: break-word !important;
            }
            .mobile-user-message 
            {
                font-family: "Poppins", sans-serif !important;
                text-align: start;
                margin-top: 25px !important;
                display:flex;
            }
            .web-user-message 
            {
                font-family: "Poppins", sans-serif !important;
                text-align: end;    
                margin-top: 25px !important;
            }
            .web-user-messagetwo
            {
                font-family: "Poppins", sans-serif !important;
                display:flex;
            }
            .mobile-user-messagetwo
            {
                font-family: "Poppins", sans-serif !important;
                display:flex;
            }
            // .logo-brand
            // {
            //         margin-top: 30px;
            //         margin-bottom: 10px;
                    
            // }
            .logo-brand img
            {
                font-family: "Poppins", sans-serif !important;
                margin-left: auto !important;
                margin-right: auto !important;
            }
            
            .logo-brand-text
            {
                font-family: "Poppins", sans-serif !important;
                text-align: center;
            }
            
           @media screen and (min-width: 320px) and (max-width: 900px)
           {
               .iconimage
               {
                   width:20% !important;
                   z-index:99;
               }
               .loginPage
               {
                   width:76% !important;
               }
               .LiveChatText img
               {
                   padding-top:5px;
                   width:100%;
               }
              
               .MainChatBody
               {
                   width:76% !important;
               }
               #submitButton
               {
                   width:20% !important;
                   background-color:white !important;
                   margin:0px !important;
                   margin-right:20px !important;
               }
               .chatinputfiled
               {
                width:80% !important;
               }
               .input
               {
                   width:100% !important;
                   display:flex;
                 
               }
               .LiveChatText
               {
                width:25%;
               }
               .LiveChatText_1
               {
                width:50%;
               }
               .close_m
               {
                width:25%;
               }
               .closebtn
               {
                width:70%;
                margin-top:5px !important;
               }
              .iconchat
              {
                bottom: 14rem !important;
              }
              .callouts li
              {
                background-color: #ff6600 !important ;
                color: white !important;
              }
              .callouts--bottom:after 
              {
                border-top: 24px solid #fff;
              }
           }
        .bodyClass
        {
            
            z-index: 999 !important;
        }
        .TimeText
        {
            font-family: "Poppins", sans-serif !important;
            font-size: 12px !important;
            margin-left: 12px !important; 
            margin-top: 7px !important; 
        }
        .MobileImageUser
        {
            font-family: "Poppins", sans-serif !important;
            width:10% !important;
        }
        .MobileImageUser img
        {
            font-family: "Poppins", sans-serif !important;
            margin-top: 4px !important;
        }
        .shake {
            animation: shake-animation 4.72s ease infinite;
            transform-origin: 50% 50%;
          }
          .element {
            margin: 0 auto;
          }
          @keyframes shake-animation {
             0% { transform:translate(0,0) }
            1.78571% { transform:translate(5px,0) }
            3.57143% { transform:translate(0,0) }
            5.35714% { transform:translate(5px,0) }
            7.14286% { transform:translate(0,0) }
            8.92857% { transform:translate(5px,0) }
            10.71429% { transform:translate(0,0) }
            100% { transform:translate(0,0) }
          }
          .iconchat
          {
            position: fixed !important;
            height: 10px !important;
            bottom: 31vh !important;
            right: 18px !important;
          }
          .callouts {
            list-style-type: none !important;
          }
          
          li + li {
            margin-left: 3.3333% !important;
          }
          .callouts li 
          {
            padding: 15px !important;
            background-color: #ff6600 ;
            border-radius: 4px !important;
            color:#fff !important;
          }
          .callouts--bottom:before {
            content: "" !important;
            position: absolute !important;
            width: 0 !important;
            height: 0 !important;
            right: 11px !important;
            bottom: -42px !important;
            border: 10px solid transparent !important;
            border-top: 32px solid rgb(193,193,193) !important;
            border-top: 32px solid rgba(193,193,193,0.5) !important;
            z-index: 2 !important;
          }
          .callouts--bottom:after {
            content: "" !important;
              position: absolute !important;
              right: 13px !important;
              bottom: -31px !important;
              border: 8px solid transparent !important;
              border-top: 24px solid #ff6600 !important;
              z-index: 3 !important;
          }          
        </style>
    </head>
    
    <body class="bodyClass">
        <!-- //Outside Icon  -->
        <div class="iconchat">
            <ul class="shake callouts">
                <li class="element callouts--bottom">Hi  I am here to help you !</li>
            </ul>
            <img onclick="LoginPage()" class="iconimage" width="4%"
                src="https://policylife.in/wp-content/uploads/2023/09/cropped-fav-icon.png" />
        </div>
        <!-- //Chat Home -->
        <div id="showchatbody" class="MainChatBody">
            <div class="mycontainer">
                <div class="row1">
                    <div class="col-lg-3 LiveChatText"><img width="100%"
                            src="https://policylife.in/wp-content/uploads/2023/09/cropped-fav-icon.png"></div>
                    <div class="col-lg-6 LiveChatText_1">Help Chat
                    </div>
                    <div class="col-lg-3 close_m"><img class="closebtn" width="30%" onclick="CloseChat()"
                            src="https://img.icons8.com/?size=512&id=higEMOAwInv1&format=png" /></div>
                </div>
            </div>
            <!-- <div class="LivechatText innerChatLiveChat">
                                <div id="userStatus"></div><img class="closebtn" width="10%" onclick="CloseChat()"
                                    src="https://img.icons8.com/?size=512&id=higEMOAwInv1&format=png" />
                            </div> -->
            <div class="messagesbody" id="scrollableDiv">
                <div id="messagesContainer1"></div>
                <div id="secoundTxtMsg"></div>
                <div id="secoundTxtMsg2"></div>
                <div id="messagesContainer"></div>
            </div>
            <div class="input">
                <input class="chatinputfiled" type="text" id="messageInput" />
                <button id="submitButton">
                    <img class="sendBtnChat" src="https://policylife.in/wp-content/uploads/2023/10/send.png" alt="sent" />
                </button>
            </div>
        </div>    
    </body>
    
    </html>';
}
// <!-- //Login Page  -->
//         <div id="loginPage" class="loginPage">
//             <div class="container">
//                 <div class="row1">
//                     <div class="col-lg-3 LiveChatText"><img width="100%"
//                             src="https://vivekanandahealth.com/wp-content/uploads/2023/08/112x112.png"></div>
//                     <div class="col-lg-6 LiveChatText_1">Live Chat</div>
//                     <div class="col-lg-3 close_m"><img class="closebtn" width="30%" onclick="CloseChat()"
//                             src="https://img.icons8.com/?size=512&id=higEMOAwInv1&format=png" /></div>
//                 </div>
//             </div>
//             <div class="logo-brand">
//                 <img src="https://vivekanandahealth.com/wp-content/uploads/2023/08/112-png.png"/>
//             </div>  
//             <div class="logo-brand-text" >VHG Chat</div>
//             <div class="LoginmainDiv">
//                 <div class="UserName">
//                     <input id="userName" placeholder="Name" class="usernameinput" type="text" />
//                 </div>
//             </div>
//             <button onclick="LoginPage()" class="startBtn">Start Chat</button>
//         </div>
add_shortcode('WebtoChat', 'custom_shortcode_function');
function my_admin_menu() {
    add_menu_page(
        'Firebase Data',
        'Firebase Data',
        'manage_options',
        'firebase-data',
        'firebase_data_page_callback'
    );
}
add_action('admin_menu', 'my_admin_menu');
function firebase_data_page_callback() 
{
    ?>
    <!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.25/css/jquery.dataTables.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/buttons/2.0.1/css/buttons.dataTables.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.0.1/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.0.1/js/buttons.html5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js"></script>
    <script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-firestore.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .BodyTable
        {
            padding: 10px;
        }
        #userDataTable_length
        {
            display:none !important;
        }
        #userChart
        {
            width: 30% !important;
            height: 30% !important;
        }
        .headingstyle
        {
            text-align: center;
            background: #751879;
            padding: 20px;
            color: white;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <h2 class="headingstyle">Web to App Chat Reports</h2>
    <h2>Total User Count: <span id="userCount">0</span></h2>
    <canvas id="userChart" width="20%" height="20%  "></canvas> 
    <div class="BodyTable">
        <table id="userDataTable" class="display" style="width:100%">
            <thead>
                <tr>
                    <th>UID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Date</th>       
                </tr>
            </thead>
            <tbody>
                <!-- Data will be loaded here dynamically -->
            </tbody>
        </table>
    </div>
    <script>
        var firebaseConfig1 = {
    apiKey: "AIzaSyBPC-9B_t-iCibBKlOQslJMwmAyruwkTTk",
    authDomain: "web2app-5336c.firebaseapp.com",
    databaseURL: "https://web2app-5336c-default-rtdb.firebaseio.com",
    projectId: "web2app-5336c",
    storageBucket: "web2app-5336c.appspot.com",
    messagingSenderId: "246080973339",
    appId: "1:246080973339:web:e2a19a6053e615a32be6be",
    measurementId: "G-VPD9B41LTW"
};

firebase.initializeApp(firebaseConfig1);

const db = firebase.firestore();
const usersCollection = db.collection("users");

$(document).ready(function () {
    const table = $('#userDataTable').DataTable({
        buttons: [
            'copy', 'csv', 'excel', 'pdf', 'print'
        ],
        dom: 'Bfrtip', // Add buttons to the DataTable layout
        columns: [
            { data: 'uid' },
            { data: 'name' },
            { data: 'email' },
            { data: 'date', render: formatDate },
        ],
    });

    usersCollection.get().then((querySnapshot) => {
        let userCount = 0;
        querySnapshot.forEach((doc) => {
            const userData = doc.data();
            table.row.add(userData).draw();
            userCount++;
        });

        document.getElementById("userCount").textContent = userCount;

        const userChart = new Chart(document.getElementById("userChart"), {
            type: 'pie',
            data: {
                labels: ['User Count'],
                datasets: [{
                    label: 'User Count',
                    data: [userCount],
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }).catch((error) => {
        console.error("Error getting documents: ", error);
    });
});

function formatDate(date) {
    const formattedDate = new Date(date.seconds * 1000).toLocaleString();
    return formattedDate;
}
    </script>
</body>
</html>
    <?php
}


