/**
 * @author Andy Woods
 */

var x_utils = (function() {
	var api = {}
	
	function loadTxt(path, success, error)
		{
			var xhr = new XMLHttpRequest();
			xhr.onreadystatechange = function()
			{
				if (xhr.readyState === XMLHttpRequest.DONE) {
					if (xhr.status === 200) {
						if (success)
							success(xhr.responseText);
					} else {
						if (error)
							error(xhr);
					}
				}
			};
			xhr.open("GET", path, true);
			xhr.send();
		}
		
		api.urlParams = {};
		(window.onpopstate = function () {
			var match,
				pl     = /\+/g,  // Regex for replacing addition symbol with a space
				search = /([^&=]+)=?([^&]*)/g,
				decode = function (s) { return decodeURIComponent(s.replace(pl, " ")); },
				query  = window.location.search.substring(1);

			while (match = search.exec(query))
			   api.urlParams[decode(match[1])] = decode(match[2]);
		})();
			
		
		function get_devices(str){
			var pos = str.split('devices=');

			if(pos.length==1) return undefined
			
			str = str.split('devices=')[1];
			var seq = '';
			var add = 0;
			var sym;

			while(add<100){
				sym = str.charAt(add);
				if(sym !=" ") seq += sym;
				else break;
				add++;
			}
			seq = seq.substr(1, seq.length-2);

			return seq.split(",");

		}
		
		function check_devices(devices){
		//https://github.com/matthewhudson/device.js
		//ios , iphone , ipod , ipad , android , androidPhone , androidTablet , blackberry , blackberryPhone , blackberryTablet , windows , windowsPhone , windowsTablet , fxos , fxosPhone , fxosTablet , meego , cordova , nodeWebkit , mobile , tablet , desktop , television , portrait , landscape , noConflict
			var deviceNam;
			var negative;
			for(var i=0;i<devices.length;i++){
				deviceNam = devices[i];
				if(deviceNam.charAt(0) == "!"){
					negative = true;
					deviceNam = deviceNam.substr(1);
				} else{
					negative = false;
				}
				
				if(device.hasOwnProperty(deviceNam) == false){
					return {'is_good': false, 'message': 'Experimenter error. Asked to screen for an unknown device: '+deviceNam};
				}
				else{
					var result = device[deviceNam]();
					if(negative ==true && result == true){
						return {'is_good': false, 'message':"your experimenter unfortunately does not want their study to run on your device ("+deviceNam+")."};
					}
					else if(negative == false && result == false){
						return {'is_good': false, 'message':"your experimenter unfortunately only wants their study to run on this device (which is not yours): "+deviceNam+"."};
					}
				}	
			}
			return {'is_good': true};
		}
		
		
		
		api.check_device_ok = function(success_cb, failure_cb){

			if('script' in api.urlParams){
				script_name = api.urlParams['script'];

				var success = function(script){
					if(api['expt_script'] == undefined){
						api['expt_script'] = script;
						
						devices = get_devices(script);
						
						if(devices === undefined){
							if(success_cb != undefined) success_cb();
							return;
						}
						
						var response = check_devices(devices);

						if(response.is_good == true) {
							if(success_cb != undefined) success_cb();
							return;
						}
						else{
							if(failure_cb != undefined) failure_cb(response.message);
							return;
						}
					}
				}
				loadTxt(script_name, success);
			}
			
			else{
				if(success_cb != undefined) success_cb();
				return;
			}
		
			
		}
	
	return api;
}());