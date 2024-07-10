# RK4

simTime = 10^1
dt = 10^-4


mutable struct bodyState_s
  position::Float64;
  velocity::Float64;
  
end

global currentBodyState = bodyState_s(0.0, 0.0);


mutable struct deltaState_s
  velocity::Float64;
  acceleration::Float64;
end

acc = 2.0; #ms^-2

function deltaFunction(localBodyState)::deltaState_s
  out::deltaState_s = deltaState_s(0.0, 0.0);
  out.velocity = localBodyState.velocity;
  out.acceleration = acc;
  out;
end

function multiplyDsWScalar(ds::deltaState_s, scalar::Float64)::bodyState_s
  out::bodyState_s = bodyState_s(ds.velocity * dt, ds.acceleration * dt) # type is bodyState because we are multiplying by time, velocity * time = distance etc.
  out
end

function addBs(bs1, bs2)::bodyState_s
  out::bodyState_s = bodyState_s(bs1.position + bs2.position, bs1.velocity + bs2.velocity)
  out
end

result = deltaState_s(0.0, 0.0)
for i in range(1, simTime/dt)

  k1 = deltaFunction(currentBodyState);
  k2 = deltaFunction(addBs(currentBodyState, multiplyDsWScalar(k1, dt/2)))
  k3 = deltaFunction(addBs(currentBodyState, multiplyDsWScalar(k2, dt/2)))
  k4 = deltaFunction(addBs(currentBodyState, multiplyDsWScalar(k3, dt)))
 
  currentBodyState.position += dt/6*(k1.velocity + 2*k2.velocity + 2*k3.velocity + k4.velocity)
  currentBodyState.velocity += dt/6*(k1.acceleration + 2*k2.acceleration + 2*k3.acceleration + k4.acceleration)

  
  
end

println(currentBodyState)

# bodyState_s(100.00066666663821, 19.999999999980066)
# exact: (100, 20)