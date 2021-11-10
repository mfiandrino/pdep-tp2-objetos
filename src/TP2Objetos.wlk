class Mensajero
{
	var property sector
	method puedeMandar(mensaje) = mensaje.length() >= 20
}

object chasqui
{
	method puedeMandar(mensaje) = mensaje.length() < 50
	method costo(mensaje) = mensaje.length() * 2
}

object sherpa
{
	var property valorMensaje = 60

	method puedeMandar(mensaje) = mensaje.length().even()
	method costo(mensaje) = valorMensaje
}

object messich
{
	var property valorCosto = 10
	
	method puedeMandar(mensaje) = not mensaje.startsWith('a') //Otra opción podría ser mensaje.take(1) != 'a' 
	method costo(mensaje) = valorCosto * mensaje.words().size()
}

object pali
{
	method puedeMandar(mensaje) = self.esPalindromo(mensaje)
	
	method esPalindromo(mensaje)
	{
		const mensajeSinEspacios = mensaje.words().join("")
		return mensajeSinEspacios.equalsIgnoreCase(mensajeSinEspacios.reverse())
	}
	
	method costo(mensaje)
	{
		const costo = mensaje.length() * 4
		return costo.min(80)
	} 
}

object pichca
{
	method puedeMandar(mensaje) = mensaje.words().size() > 3
	method costo(mensaje) = mensaje.size() * (3.randomUpTo(7))
}

class MensajeroEstandar
{	
	var property sector
	
	method puedeMandar(mensaje) = mensaje.length() >= 20
	method costo(mensaje) = self.cantidadDePalabras(mensaje) + sector.cobro()
	method cantidadDePalabras(mensaje) = mensaje.words().size()
}

object enviosRapidos
{
	method cobro() = 20
}

object enviosEstandar
{
	method cobro() = 15
}

object enviosVIP
{
	method cobro() = 30
}

object agenciaMensajeria
{
	const mensajeros = [chasqui,sherpa,messich,pali,pichca,new MensajeroEstandar(sector = enviosRapidos)]
	const property historial = []
	
	
	
	method recibirMensaje(mensaje)
	{
		self.verificarMensajeVacio(mensaje)
		self.registrarEntrada(mensaje,self.pedirMensajero(mensaje),new Date())
	}
	
	method verificarMensajeVacio(mensaje)
	{
		if(mensaje.isEmpty())
			throw new DomainException(message = "El mensaje esta vacio, no puede realizarse la operacion")
	}
	
	method mensajerosPosibles(mensaje)
	{
		const mensajerosPosibles = mensajeros.filter({unMensajero => unMensajero.puedeMandar(mensaje)})
		if(mensajerosPosibles.isEmpty())
			throw new DomainException(message = "No hay mensajeros para enviar ese mensaje")
		return mensajerosPosibles
	}
	
	method pedirMensajero(mensaje) = self.mensajerosPosibles(mensaje).min({unMensajero => unMensajero.costo(mensaje)})
	
	method registrarEntrada(mensaje,mensajero,fecha)
	{
		historial.add(new EntradaHistorial(mensaje = mensaje, mensajero = mensajero, fecha = fecha))
	}
		
// 4) Ganancia neta del mes - Común
	method historialDelMes() = historial.filter({input => input.fecha() >= new Date().minusDays(30)})
	method GananciaNetaXMes() = self.historialDelMes().sum({input => input.gananciaPorMensaje()})
	
// 5) Empleado del mes - Común
	method obtenerEmpleadoDelMes()
	{
		const losMensajerosQueEnviaron = self.historialDelMes().map({input => input.mensajero()})
		return losMensajerosQueEnviaron.max({mensajero => losMensajerosQueEnviaron.occurrencesOf(mensajero)})
	}
}

class EntradaHistorial 
{
	var property mensaje
	var property mensajero
	var property fecha
	
	method gananciaPorMensaje()
	{
		if(mensaje.size() < 30)
			return 500 - mensajero.costo(mensaje)
		else
			return 900 - mensajero.costo(mensaje)
	}
}


//Punto 8:
object mensajeElocuente{
	method gradoDeElocuencia(mensaje){
	return	mensaje.words().filter({palabra => palabra.size() < 3 }).size() +1
	}
	method ganancia(mensaje){
		if(mensaje.size() < 30){
			return 500 * self.gradoDeElocuencia(mensaje)
			} else {
				return 900 * self.gradoDeElocuencia(mensaje)
			}
	}
	method costo(mensaje){
		return 0.1 * self.ganancia(mensaje)
	}
}


//Punto 9:

object mensajeCifrado {
	method entregarAlRevez(mensaje) = mensaje.reverse()
	method costoMensajeCifrado(mensaje, mensajero) = mensajero.costo(mensaje) + 3 * mensaje.indexOf("a")
	}
	
