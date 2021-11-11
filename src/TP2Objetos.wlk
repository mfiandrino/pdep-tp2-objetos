class Mensajero
{
	var property tipoDeMensajero
	var property sector	
	method puedeMandar(mensaje) = mensaje.length() >= 20
	method costo(mensaje)
	
	method enviarMensaje(mensaje) = tipoDeMensajero.enviarMensaje(mensaje)
}

object chasqui inherits Mensajero(sector = enviosRapidos, tipoDeMensajero = paranoico)
{
	override method puedeMandar(mensaje) = super(mensaje) && mensaje.length() < 50
	override method costo(mensaje) = mensaje.length() * 2
}

object sherpa inherits Mensajero(sector = enviosEstandar, tipoDeMensajero = new Alegre(alegria = 100))
{
	var property valorMensaje = 60

	override method puedeMandar(mensaje) = super(mensaje) && mensaje.length().even()
	override method costo(mensaje) = valorMensaje
}

object messich inherits Mensajero(sector = enviosVIP, tipoDeMensajero = serio)
{
	var property valorCosto = 10
	
	override method puedeMandar(mensaje) = super(mensaje) && not mensaje.startsWith('a') //Otra opción podría ser mensaje.take(1) != 'a' 
	override method costo(mensaje) = valorCosto * mensaje.words().size()
}

object pali inherits Mensajero(sector = enviosRapidos, tipoDeMensajero = paranoico)
{
	override method puedeMandar(mensaje) = super(mensaje) && self.esPalindromo(mensaje)
	
	method esPalindromo(mensaje)
	{
		const mensajeSinEspacios = mensaje.words().join("")
		return mensajeSinEspacios.equalsIgnoreCase(mensajeSinEspacios.reverse())
	}
	
	override method costo(mensaje)
	{
		const costo = mensaje.length() * 4
		return costo.min(80)
	} 
}

object pichca inherits Mensajero(sector = enviosEstandar, tipoDeMensajero = serio)
{
	override method puedeMandar(mensaje) = super(mensaje) && mensaje.words().size() > 3
	override method costo(mensaje) = mensaje.size() * (3.randomUpTo(7))
}

class MensajeroEstandar inherits Mensajero
{	
	override method costo(mensaje) = self.cantidadDePalabras(mensaje) + sector.cobro()
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

object paranoico
{
	method enviarMensaje(mensaje) = new MensajeCifrado(contenido = mensaje)
}

class Alegre
{
	var property alegria
	method enviarMensaje(mensaje)
	{
		if(alegria > 10)
		{
			var dur
			if(alegria.even())
				dur = 6 * alegria
			else
				dur = 500
			return new MensajeCantado(contenido = mensaje, duracion = dur)
		}
		else
			return new Mensaje(contenido = mensaje)
	}
}

object serio
{
	var contador = 0
	
	method enviarMensaje(mensaje)
	{
		if(contador < 3)
		{
			contador++
			return new MensajeElocuente(contenido = mensaje)
		}
			
		else
			return new MensajeCifrado(contenido = mensaje)
	}	
}

object agenciaMensajeria
{
	const historial = []
	const mensajeros = [chasqui,sherpa,messich,pali]
	
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
		historial.add(new EntradaHistorial(mensajeH = mensajero.enviarMensaje(mensaje), mensajeroH = mensajero, fechaH = fecha))
	}

	// 4) Ganancia neta del mes - Común
	method historialDelMes() = historial.filter({input => input.fechaH() >= new Date().minusDays(30)})
	method GananciaNetaXMes() = self.historialDelMes().sum({input => input.gananciaPorMensaje()})
	
	// 5) Empleado del mes - Común
	method obtenerEmpleadoDelMes()
	{
		const losMensajerosQueEnviaron = self.historialDelMes().map({input => input.mensajeroH()})
		return losMensajerosQueEnviaron.max({mensajero => losMensajerosQueEnviaron.occurrencesOf(mensajero)})
	}	
}

class EntradaHistorial 
{
	var property mensajeH
	var property mensajeroH
	var property fechaH

	method gananciaPorMensaje() = mensajeH.ganancia() - mensajeH.costo() - mensajeroH.costo(mensajeH.contenido())
}

class Mensaje
{
	var property contenido
	
	method ganancia()
	{
		if(contenido.size() < 30)
			return 500
		else
			return 900
	}
	
	method costo() = 0
}

class MensajeCantado inherits Mensaje
{
	var property duracion
	override method costo() = duracion * 0.1
}

//Punto 8:
class MensajeElocuente inherits Mensaje
{
	method gradoDeElocuencia() = contenido.words().filter({palabra => palabra.size() < 3 }).size() + 1
	override method ganancia() = super() * self.gradoDeElocuencia()
	override method costo() = 0
}

//Punto 9:
class MensajeCifrado inherits Mensaje
{
	override method contenido() = contenido.reverse()
	
	override method costo() = 3 * contenido.indexOf("a")
}


