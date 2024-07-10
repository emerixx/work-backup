# leapfrog

simTime = 10^1
dt = 10^-4


mutable struct bodyState_s
  position::Float64;
  velocity::Float64;
  accOld::Float64;
end

global currentBodyState = bodyState_s(0.0, 0.0, 0.0);


mutable struct deltaState_s
  velocity::Float64;
  acceleration::Float64;
end

acc = 2.0; #ms^-2

function deltaFunction(localBodyState)::deltaState_s
  out::deltaState_s = deltaState_s(0.0, 0.0);
  out.velocity = localBodyState.velocity;
  out.acceleration = acc;
  return out;
end
result = deltaState_s(0.0, 0.0)
for i in range(1, simTime/dt)
  global currentBodyState.velocity += 1/2*(result.acceleration + currentBodyState.accOld)*dt
  global result = deltaFunction(currentBodyState);
  
  
  global currentBodyState.position += result.velocity*dt + 1/2*result.acceleration*dt^2
  global currentBodyState.accOld = result.acceleration
  
end

println(currentBodyState)

# bodyState_s(99.99999999997155, 19.999799999980066, 2.0)
# exact: (100, 20)