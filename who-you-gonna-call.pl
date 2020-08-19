tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(egon, plumero).
tiene(peter, trapeador).
tiene(winston, varitaNeutrones).

herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

satisfaceNecesidad(Integrante, Herramienta):-
    tiene(Integrante, Herramienta).

satisfaceNecesidad(Integrante, aspiradora(PotenciaRequerida)):-
    tiene(Integrante, aspiradora(Potencia)),
    Potencia >= PotenciaRequerida.

realizarTarea(Integrante, Tarea):-
    herramientasRequeridas(Tarea, _),
    tiene(Integrante, varitaNeutrones).

realizarTarea(Integrante, Tarea):-
    tiene(Integrante, _),
    herramientasRequeridas(Tarea, Herramientas),
    forall(member(Herramienta, Herramientas), satisfaceNecesidad(Integrante, Herramienta)).

tareaPedida(grace, ordenarCuarto, 30).
tareaPedida(maro, encerarPisos, 60).
tareaPedida(maro, limpiarBanio, 14).
tareaPedida(greta, cortarPasto, 70).
tareaPedida(grace, limpiarTecho, 50).

precio(ordenarCuarto, 40).
precio(encerarPisos, 50).
precio(limpiarBanio, 100).
precio(cortarPasto, 30).
precio(limpiarTecho, 150).

cotizarTarea(Cliente, Monto):-
    tareaPedida(Cliente, _, _),
    findall(PrecioTarea, calcularPrecioTarea(Cliente, PrecioTarea), Precios),
    sum_list(Precios, Monto).

calcularPrecioTarea(Cliente, PrecioTarea):-
    tareaPedida(Cliente, Tarea, Metros),
    precio(Tarea, Precio),
    PrecioTarea is Metros * Precio.

aceptaPedido(Integrante, Cliente):-
    forall(tareaPedida(Cliente, Tarea, _), realizarTarea(Integrante, Tarea)),
    estaDispuestoAceptarlo(Integrante, Cliente).

estaDispuestoAceptarlo(ray, Cliente):-
    not(tareaPedida(Cliente, limpiarTecho, _)).

estaDispuestoAceptarlo(winston, Cliente):-
    cotizarTarea(Cliente, Monto),
    Monto > 500.

estaDispuestoAceptarlo(peter, Cliente):-
    tareaPedida(Cliente, _, _).

estaDispuestoAceptarlo(egon, Cliente):-
    forall(tareaPedida(Cliente, Tarea, _),
    not(tareaCompleja(Tarea))).

tareaCompleja(Tarea):-
    herramientasRequeridas(Tarea, Herramientas),
    length(Herramientas, Cantidad),
    Cantidad >= 2.

tareaCompleja(limpiarTecho).
    
