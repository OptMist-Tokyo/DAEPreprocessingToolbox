Document
====

* [daeJacobianFunction](#daeJacobianFunction) : a MALTAB function handle that returns the Jacobian matrices.
* [isLowIndex](#isLowIndex) : check if a DAE is of low index (0 or 1).
* [orderMatrix](#orderMatrix) : matrix storing differential orders of variables in DAE system.
* [reduceIndex](#reduceIndex) : 
* [systemJacobian](#systemJacobian) : system Jacobian matrix of DAE system.

## daeJacobianFunction
### Syntax
```matlab
Jfun = daeJacobianFunction(eqs, vars)
Jfun = daeJacobianFunction(eqs, vars, p1, ..., pN)
```

### Description
* `Jfun = daeJacobianFunction(eqs, vars)` converts a symbolic first-order DAE `eqs` to a MATLAB function handle `Jfun` that returns the Jacobian matrices of `eqs` by `vars` and of `eqs` by `diff(vars)` at the given `(t, y0, yp0)`.
`Jfun` is acceptable as a value of the `jacobian` option in `odeset` for `ode15i`.
* `Jfun = daeJacobianFunction(eqs, vars, p1, ..., pN)` lets you specify the symbolic parameters of the system as `p1`, ..., `pN`.

### Examples
```matlab
syms x(t) y(t)
eqs = [x(t)*y(t), diff(x(t))+diff(y(t))];
vars = [x, y];
Jfun = daeJacobianFunction(eqs, vars)
[Jy, Jyp] = Jfun(0, [3; 4], [0; 0])
```

> ```
> Jfun = 
> 
>   function_handle with value:
>
>     @(t,in2,in3)deal(reshape([in2(2,:),0.0,in2(1,:),0.0],[2,2]),reshape([0.0,1.0,0.0,1.0],[2,2]))
> 
> Jy =
> 
>      4     2
>      0     0
> 
> Jyp =
> 
>      0     0
>      1     1
> ```

```matlab
syms x(t) y(t) a b
eqs = [a*x(t), a*b*diff(y(t))];
vars = [x, y];
Jfun = daeJacobianFunction(eqs, vars, a, b)
[Jy, Jyp] = Jfun(0, [2; 3], [4; 5], 6, 7)
```

> ```
> Jfun =
> 
>   function_handle with value:
>
>     @(t,in2,in3,a,b)deal(reshape([a,0.0,0.0,0.0],[2,2]),reshape([0.0,0.0,0.0,a.*b],[2,2]))
> 
> Jy =
> 
>      6     0
>      0     0
> 
> Jyp =
> 
>      0     0
>      0    42
> ```

## isLowIndex
### Syntax
```matlab
isLowIndex(eqs, vars)
```

### Description
`isLowIndex(eqs, vars)` returns `true` if a DAE `eqs` is of low differential index (0 or 1). This function can be applied to DAEs with higher order derivatives.

### Examples
```matlab
syms x(t) y(t)
eqs = [x(t)*y(t), diff(x(t))+diff(y(t))];
vars = [x, y];
isLowIndex(eqs, vars)
```
> ```
> ans =
> 
>   logical
> 
>    1
> ```

```matlab
syms x(t) y(t)
eqs = [diff(x(t),2)+y(t), diff(x(t),2)+x(t)+y(t)];
vars = [x, y];
isLowIndex(eqs, vars)
```
> ```
> ans =
> 
>   logical
> 
>    0
> ```


## orderMatrix

### Syntax
```matlab
orderMatrix(eqs, vars)
```

### Description
`orderMatrix(eqs, vars)` returns a matrix whose `(i, j)`th entry contains the maximum `k` such that `eqs(i)` depends on the `k`th order derivative of `vars(j)`. If `eqs(i)` does not depend on any derivative of `vars(j)`, the entry is set to `-Inf`.

### Examples
```matlab
syms x(t) y(t)
eqs = [x(t)*y(t), diff(x(t))+diff(y(t))];
vars = [x, y];
orderMatrix(eqs, vars)
```
> ```
> ans =
> 
>      0     0
>      1     1
> ```

## reduceIndex

### Syntax
```matlab
[newEqs, newVars] = reduceIndex(eqs, vars)
```

### Description
* `[newEqs, newVars] = reduceIndex(eqs, vars)` converts a DAE `eqs` to an equivalent DAE `newEqs` of index at most 1. 

### Examples

```matlab
syms y(t) z(t) T(t) g m L
eqs = [
    m*diff(y(t), 2) == y(t)*T(t)/L
    m*diff(z(t), 2) == z(t)*T(t)/L - m*g
    y(t)^2 + z(t)^2 == L^2
];
vars = [y, z, T];
[newEqs, newVars, R] = reduceIndex(eqs, vars)
```

> ```
> newEqs =
> 
>                                                  m*Dytt(t) - (T(t)*y(t))/L
>                                   m*diff(z(t), t, t) + g*m - (T(t)*z(t))/L
>                                                    - L^2 + y(t)^2 + z(t)^2
>                                       2*Dyt(t)*y(t) + 2*z(t)*diff(z(t), t)
>  2*Dytt(t)*y(t) + 2*Dyt(t)^2 + 2*diff(z(t), t)^2 + 2*z(t)*diff(z(t), t, t)
> 
> 
> newVars =
> 
>     y(t)
>     z(t)
>     T(t)
>   Dyt(t)
>  Dytt(t)
> 
> 
> R =
> 
> [  Dyt(t),    diff(y(t), t)]
> [ Dytt(t), diff(y(t), t, t)]
> ```

## systemJacobian

### Syntax
```matlab
systemJacobian(eqs, vars)
```

### Description

`systemJacobian(eqs, vars)` returns the system Jacobian matrix of a DAE `eqs` with respect to `vars`. The `(i, j)`th entry of the resulting matrix is the derivative of `eqs(i)^(p(i))` by `vars(j)^(q(j))`, where `p` and `q` are a dual optimal solution of the assignment problem obtained from the order matrix of the DAE system
(here, `x^k` means the `k`th-order time derivative `d^k x(t)/dt^k` of `x(t)`).

### Examples
```matlab
syms x(t) y(t)
eqs = [x(t)*y(t), diff(x(t))+diff(y(t))];
vars = [x, y];
systemJacobian(eqs, vars)
```

> ```
> ans =
> 
> [ y(t), x(t)]
> [    1,    1]
> ```
