<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Src="~/ChooseGIF.ascx" TagPrefix="uc1" TagName="ChooseGIF" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <META HTTP-EQUIV="refresh" CONTENT="60"/>

<style>
    .centered {
        display: table;
        margin: 0 auto;
    }
    </style>   

</head>
<body onload="">

    <form id="form1" runat="server">
    <div class="centered">
    Latest Picture<br />
    <img src="~\latest.jpg" style="width: 50%; height: 50%;"/>
    </div>
    </form>

    <div>
        <uc1:ChooseGIF runat="server" ID="ChooseGIF" />

    </div>

</body>
</html>
