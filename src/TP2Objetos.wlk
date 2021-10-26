

 






object agenciaMensajeria
{ 
	method puedeMandar(mensaje) =  mensaje != "" 
	
	const mensajeros = [pichca, mensajeroEstandar]
	
	method mensajerosPosibles(mensaje) = mensajeros.filter({unMensajero => unMensajero.puedeMandar(mensaje)}) 
	
	method pedirMensajero(mensaje) = self.mensajerosPosibles(mensaje).min({unMensajero => unMensajero.costo(mensaje)})
	
}
