<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN'
   'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>
<html>
<head>
	<meta http-equiv="expires" content="-1" />
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="copyright" content="2013, Web Site Management" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" >
	<title>Set Element Display in Project Structure</title>
	<link rel="stylesheet" href="css/bootstrap.min.css" />
	<style type="text/css">
		body
		{
			padding: 10px;
		}
		textarea, input
		{
			width: 95%;
			height: 150px;
		}
	</style>
	<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
	<script type="text/javascript" src="RqlConnector.js"></script>
	<script type="text/javascript">
		var _ElementGuid = '<%= session("treeguid") %>';
		var LoginGuid = '<%= session("loginguid") %>';
		var SessionKey = '<%= session("sessionkey") %>';
		var RqlConnectorObj = new RqlConnector(LoginGuid, SessionKey);
	
		$(document).ready(function() {
			$('.form-actions .btn').hide();
		
			LoadContentClassElement(_ElementGuid);
		});
		
		function LoadContentClassElement(ElementGuid)
		{
			$('#processing').modal('show');
		
			var strRQLXML = '<PROJECT><TEMPLATE><ELEMENT action="load" guid="' + ElementGuid + '"/></TEMPLATE></PROJECT>';
			RqlConnectorObj.SendRql(strRQLXML, false, function(data){
				
				var IsInvisible = $(data).find('ELEMENT').attr('eltinvisibleinclient');
				switch(IsInvisible)
				{
					case '1':
						$('#display-status').text('HIDDEN');
						$('#display-status').addClass('btn-warning');
						$('#show').show();
						break
					case '0':
						$('#display-status').text('SHOWN');
						$('#display-status').addClass('btn-success');
						$('#hide').show();
						break
				}

				$('#processing').modal('hide');
			});
		}
		
		function ShowElement()
		{
			SetElementDisplay(_ElementGuid, true);
		}
		
		function HideElement()
		{
			SetElementDisplay(_ElementGuid, false);
		}
		
		function SetElementDisplay(ElementGuid, Show)
		{
			$('#processing').modal('show');
		
			var IsInvisible;
			
			if(Show)
			{
				IsInvisible = 0;
			}
			else
			{
				IsInvisible = 1;
			}
			
			var strRQLXML = '<PROJECT><TEMPLATE><ELEMENT action="save" guid="' + ElementGuid + '" eltinvisibleinclient="' + IsInvisible + '"/></TEMPLATE></PROJECT>';
			RqlConnectorObj.SendRql(strRQLXML, false, function(data){
				$('#processing').modal('hide');
				window.close();
			});
		}
	</script>
</head>
<body>
	<div id="processing" class="modal hide fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-header">
			<h3>Processing</h3>
		</div>
		<div class="modal-body">
			<p>Please wait...</p>
		</div>
	</div>
	<div class="form-horizontal">
		<div class="navbar navbar-inverse">
			<div class="navbar-inner">
				<span class="brand">Current Element Display Status</span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="display-status">Display Status</label>
			<div class="controls">
				<a href="#" id="display-status" class="btn disabled"></a>
			</div>
		</div>
		<div class="form-actions">
			<button class="btn btn-warning pull-right" id="hide" onclick="HideElement()">Hide</button>
			<button class="btn btn-success pull-right" id="show" onclick="ShowElement()">Show</button>
		</div>
	</div>
</body>
</html>