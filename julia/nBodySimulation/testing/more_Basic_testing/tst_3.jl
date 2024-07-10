# RK45

simTime = 10^1
dt = 10^-4

import Base.+
import Base.*


B = zeros((6, 5))
B[2, 1] = 1 / 4
B[3, 1] = 3 / 32
B[3, 2] = 9 / 32
B[4, 1] = 1932 / 2197
B[4, 2] = -7200 / 2197
B[4, 3] = 7296 / 2197
B[5, 1] = 439 / 216
B[5, 2] = -8
B[5, 3] = 3680 / 513
B[5, 4] = -845 / 4104
B[6, 1] = -8 / 27
B[6, 2] = 2
B[6, 3] = -3544 / 2565
B[6, 4] = 1859 / 4104
B[6, 5] = -11 / 40

CH = [
  16 / 135,
  0,
  6656 / 12825,
  28561 / 56430,
  -9 / 50,
  2 / 55
]


mutable struct bodyState_s
  position::Float64
  velocity::Float64

end

global currentBodyState = bodyState_s(0.0, 0.0);


mutable struct deltaState_s
  velocity::Float64
  acceleration::Float64
end

acc = 2.0; #ms^-2

function deltaFunction(localBodyState)::deltaState_s
  out::deltaState_s = deltaState_s(0.0, 0.0)
  out.velocity = localBodyState.velocity
  out.acceleration = acc
  out
end

function multiplyDsTime(ds::deltaState_s, time::Float64)::bodyState_s
  out::bodyState_s = bodyState_s(ds.velocity * time, ds.acceleration * time) # type is bodyState because we are multiplying by time, velocity * time = distance etc.
  out
end

function addBs(bs1, bs2)::bodyState_s
  out::bodyState_s = bodyState_s(bs1.position + bs2.position, bs1.velocity + bs2.velocity)
  out
end

function *(x::deltaState_s, y::Float64)
  bodyState_s(x.velocity * y, x.acceleration * y)
end

function +(x::bodyState_s, y::bodyState_s)
  bodyState_s(x.position + y.position, x.velocity + y.velocity)
end
function *(x::bodyState_s, y::Float64)
  bodyState_s(x.position * y, x.velocity * y)
end
function *(x::Float64, y::bodyState_s)
  bodyState_s(y.position * x, y.velocity * x)
end




result = deltaState_s(0.0, 0.0)
for i in range(1, simTime / dt)



  k1::bodyState_s = deltaFunction(currentBodyState) * dt
  k2::bodyState_s = deltaFunction(currentBodyState + k1 * B[2, 1]) * dt
  k3::bodyState_s = deltaFunction(currentBodyState + k1 * B[3, 1] + k2 * B[3, 2]) * dt
  k4::bodyState_s = deltaFunction(currentBodyState + k1 * B[4, 1] + k2 * B[4, 2] + k3 * B[4, 3]) * dt
  k5::bodyState_s = deltaFunction(currentBodyState + k1 * B[5, 1] + k2 * B[5, 2] + k3 * B[5, 3] + k4 * B[5, 4]) * dt
  k6::bodyState_s = deltaFunction(currentBodyState + k1 * B[6, 1] + k2 * B[6, 2] + k3 * B[6, 3] + k4 * B[6, 4] + k5 * B[6, 5]) * dt




  global currentBodyState += CH[1] * k1 + CH[2] * k2 + CH[3] * k3 + CH[4] * k4 + CH[5] * k5 + CH[6] * k6




end

println(currentBodyState)

# bodyState_s(99.99979999899676, 19.999979999581182)
# exact: (100, 20)