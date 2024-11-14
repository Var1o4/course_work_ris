<!DOCTYPE html>
<html>
<head>
    <style>
        @import url(https://fonts.googleapis.com/css?family=Open+Sans:400,700);
        @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.2.0/css/font-awesome.min.css');

        *{
            font-family: 'Open Sans', 'sans-serif', 'FontAwesome';
        }
        body{
            background: rgb(52, 56, 61);
        }
        h1{
            color: rgb(255, 255, 255);
            margin: 20px auto 0;
            width: 200px;
            text-align: center;
        }
        #wrapper{
            position: absolute;
            width: 320px;
            left: 50%;
            margin-left: -160px;
            top: 50%;
            margin-top: -75px;
        }

        /* === Registration Form === */
        #registration {
            height: 180px;
            width: 300px;
            border-radius: 8px;
            position: relative;
        }
        #registration::before {
            display: block;
            position: relative;
            height: 2px;
            background: rgb(52, 56, 61);
            content: '';
            top: 44px;
            margin-left: 20px;
            z-index: 1;
        }
        #registration input:first-of-type{
            border-top-right-radius: 8px;
            border-top-left-radius: 8px;
        }
        #registration input:last-of-type{
            border-bottom-right-radius: 8px;
            border-bottom-left-radius: 8px;
        }
        #registration  input[type="text"], #registration  input[type="email"], #registration  input[type="password"], #registration button[type="submit"]{
            background: rgb(28, 30, 33);
            box-shadow: inset -100px -100px 0 rgb(28, 30, 33); /*Prevent yellow autofill color*/
            color: rgb(52, 56, 61);
        }
        #registration  input[type="text"], #registration  input[type="email"], #registration  input[type="password"]{
            position: relative;
            display: block;
            width: 280px;
            height: 45px;
            border: 0;
            outline: 0;
            top: -2px;
            padding: 0 0 0 20px;
            font-weight: 700;
        }
        #registration  input[type="text"]:focus, #registration  input[type="email"]:focus, #registration  input[type="password"]:focus{
            color: rgb(255, 255, 255);
        }
        #registration button[type="submit"]{
            display: block;
            position: absolute;
            width: 52px;
            height: 52px;
            color: rgb(52, 56, 61);
            border-radius: 50px;
            outline: 0;
            z-index: 2;
            top: 19px;
            right: -24px;
            border: 6px solid rgb(52, 56, 61);
            font-size: 25px;
            text-indent: 0px;
            padding-left: 9px;
            padding-bottom: 3px;
            text-align: center;
        }
        #registration button[type="submit"]:hover{
            color: rgb(0, 126, 165);
            text-shadow: 0 0 10px rgb(0, 126, 165);
            cursor: pointer;
        }
        #registration p {
            color: rgb(79, 85, 97);
            padding: 0 20px;
            font-weight: 700;
            font-size: 12px;
            margin: 5px 0 0 0;
        }
        #registration p > a{
            color: rgb(111, 119, 135);
            text-decoration: none;
        }
        #registration p > a:hover{
            border-bottom: 1px solid;
        }
    </style>
</head>
<body>
<h1>Регистрация</h1>
<div id="wrapper">
    <form id="registration" action="/registration" method="post" autocomplete="off">
        <input type="text" id="user" name="name" placeholder="Имя пользователя" required/>
        <input type="email" id="email" name="email" placeholder="email" required/>
        <input type="text" id="phone" name="phoneNumber" placeholder="Номер телефона" required/>
        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
        <input type="password" id="pass" name="password" placeholder="Пароль" required/>
        <button type="submit"></button>
        <p>Уже зарегистрированны? <a href="/login">Вход</a></p>
    </form>
</div>
</body>
</html>
