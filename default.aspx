<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="PayuDirekOdemeTest._Default" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<title>OpenPayU JS+API Implementation </title>	
		<script type="text/javascript" src="https://secure.payu.com.tr/openpayu/v2/client/jquery-1.7.2.js"></script>		
		<script type="text/javascript" src="https://secure.payu.com.tr/openpayu/v2/client/json2.js"></script>		
		<script type="text/javascript" src="https://secure.payu.com.tr/openpayu/v2/client/openpayu-2.0.js"></script>		
		<script type="text/javascript" src="https://secure.payu.com.tr/openpayu/v2/client/plugin-payment-2.0.js"></script>
		<script type="text/javascript" src="https://secure.payu.com.tr/openpayu/v2/client/plugin-installment-2.0.js"></script>
		<style type="text/css">
			.card {
				width:200px;
				height: 20px;
				border:1px solid #CCC;
				margin: 1px;
				padding: 1px;
				font-size: 16px;
			}
		</style>		
		<link rel="stylesheet" type="text/css" href="openpayu-builder-2.0.css"/>		
</head>
<body>
	<form id="form1" runat="server" method="post">
	    <div id="DivPayment" runat="server">
	        <p>Kredi Kartı: <span id="card-program"></span></p>
		    <table>
		    <tr>
				    <td>Ürün Adı</td>
				    <td><input type="text" class="card" id="description" value="Kitap"/></td>
			    </tr>			

			    <tr>
				    <td>Toplam Tutar</td>
				    <td><input type="text" class="card" id="amount" value="50"/></td>
			    </tr>
								
			    <tr>
				    <td>Ad</td>
				    <td><input type="text" class="card" id="first_name" value="Burak"/></td>
			    </tr>
			    <tr>
				    <td>Soyad</td>
				    <td><input type="text" class="card" id="last_name" value="Horozoğlu"/></td>
			    </tr>
			    <tr>
				    <td>E-mail</td>
				    <td><input type="text" class="card" id="email"  value="blordk@hotmail.com"/></td>
			    </tr>
			    <tr>
				    <td>Telefon</td>
				    <td><input type="text" class="card" id="phone" value="05076804159"/></td>
			    </tr>		
				
			    <tr>
				    <td>Kart Sahibinin Adı Soyadı</td>
				    <td><div id="payu-card-cardholder-placeholder" class="card"></div></td>
			    </tr>			
			    <tr>
				    <td>Kart Numarası</td>
				    <td><div id="payu-card-number-placeholder" class="card"></div></td>				
			    </tr>
			    <tr>
				    <td>Güvenlik Numarası</td>
				    <td><div id="payu-card-cvv-placeholder" class="card"></div></td>				
			    </tr>
			    <tr>
				    <td>Son Kullanma Tarihi (Ay)</td>
				    <td><input type="text" class="card" id="payu-card-expm" value="06"/></td>				
			    </tr>
			    <tr>
				    <td>Son Kullanma Tarihi (Yıl)</td>
				    <td><input type="text" class="card" id="payu-card-expy" value="2015"/></td>
			    </tr>									
			    <tr>
				    <td>Taksit</td>
				    <td><input type="text" class="card" id="payu-card-installment"/></td>				
			    </tr>		
			    <tr>
				    <td><asp:Label ID="LblResult" runat="server" Text=""></asp:Label></td>
			    </tr>											
			    <tr>
				    <td><input type="submit" id="payu-cc-form-submit" value="Ödeme Yap"/><asp:Button ID="BtnPaymentSucceed" runat="server" Text="Onayla" onclick="BtnPaymentSucceed_Click"/></td>
			    </tr>
			    <tr>
				    <td><asp:Label ID="LblError" runat="server" Text=""></asp:Label></td>
			    </tr>					
		    </table>
		</div>
		<div id="DivPaymentSucceed" runat="server" visible="false">
		    Tahsilat işlemi başarıyla tamamlanmıştır.
		</div>
	</form>
</body>
</html>
<script type="text/javascript">// <![CDATA[
$(function () {
   OpenPayU.Installment.onCardChange(function (data) {$('#card-program').html(JSON.stringify(data.program));});
   OpenPayU.Payment.setup({id_account : "MGAZABOX",orderCreateRequestUrl:"http://localhost:61321/payupay.asmx/PayuPay"});
   $('#payu-cc-form-submit').click(function () {
   //$("#payu-card-installment").val($('#RdInstallments li input:checked').val());
   OpenPayU.Builder.addPreloader('Lütfen Bekleyin ... ');
   OpenPayU.Payment.create({orderCreateRequestData: {
            FirstName: $('#first_name').val(),
            LastName: $('#last_name').val(),
            Email: $('#email').val(),
            Phone: $('#phone').val(),
            Product: $('#description').val(),
            Amount: $('#amount').val()
        }
    }, function (response) {
         if (response.Status.StatusCode == 'OPENPAYU_SUCCESS') {
            $("#LblResult").val(JSON.stringify(response));
            var btn = document.getElementById("BtnPaymentSucceed");
            if (btn) btn.click();
        } else {
            alert('Bir hata oluştu.Lütfen kart bilgilerinizi kontrol edin.');
            $("#LblResult").val(JSON.stringify(response));                      
            OpenPayU.Builder.removePreloader();
            //$('#LblError').html(response.status + '\n' + JSON.stringify(response) );
        }
     return false;
 });
 return false;
    });
 } ());
// ]]></script>
