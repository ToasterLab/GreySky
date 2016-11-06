# http://api.nea.gov.sg/api/WebAPI/?dataset=pm2.5_update&keyref=781CF461BB6606AD28A78E343E0E41768209B2EF144E6564


parseXML = (xml) ->
	if window.DOMParser?
		parseXML = (xmlStr) ->
			(new window.DOMParser()).parseFromString(xmlStr, "text/xml")
		parseXML(xml)
	else if window.ActiveXObject? && new window.ActiveXObject("Microsoft.XMLDOM")
		parseXml = (xmlStr) ->
			xmlDoc = new window.ActiveXObject "Microsoft.XMLDOM"
			xmlDoc.async = "false"
			xmlDoc.loadXML xmlStr
			return xmlDoc
	else
		throw new Error("No XML parser found")
	
class GreySky
	constructor: (@key) ->
	willItHaze: () ->
		getBackToMe = () =>
			if xhr.status == 200 and xhr.responseText?
				@psi = xhr.responseText
				@drawHaze @psi
			else if xhr.status != 200
				alert "why: "+xhr.status
		xhr = new XMLHttpRequest();
		xhr.open("GET","http://api.nea.gov.sg/api/WebAPI/?dataset=psi_update&keyref="+@key)
		xhr.addEventListener("load", getBackToMe);
		xhr.send();
		return @psi
	drawHaze: (psi)->
		data = parseXML(psi)
		regions = data.getElementsByTagName "region"
		hazeData = []
		for place in regions
			record = place.getElementsByTagName("record")[0]
			r =
				name: place.getElementsByTagName("id")[0].textContent
				timestamp: record.getAttribute("timestamp")
				readings: []
			readings = record.getElementsByTagName("reading")
			for reading in readings
				r.readings[reading.getAttribute("type")] = reading.getAttribute("value")
			hazeData.push(r)
		console.log hazeData
		return hazeData
		

app = new GreySky "781CF461BB6606AD28A78E343E0E41768209B2EF144E6564"
console.log app.willItHaze()