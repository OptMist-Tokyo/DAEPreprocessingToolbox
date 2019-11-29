Document
====

* [daeJacobianFunction](#daeJacobianFunction) : return a MATLAB function handle that returns the Jacobian matrices.
* [isLowIndex](#isLowIndex) : check if a DAE is of low index (0 or 1).
* [orderMatrix](#orderMatrix) : return the matrix storing differential orders of variables in DAE system.
* [preprocessDAE](#preprocessDAE) : convert a DAE to another DAE to which `reduceIndex` can be applied.
* [reduceIndex](#reduceIndex) : reduce the differential index of DAEs.
* [systemJacobian](#systemJacobian) : return the system Jacobian matrix of DAE system.

## daeJacobianFunction
### Syntax
```matlab
Jfun = daeJacobianFunction(eqs, vars)
Jfun = daeJacobianFunction(eqs, vars, p1, ..., pN)
```

### Description
* `Jfun = daeJacobianFunction(eqs, vars)` converts a symbolic first-order DAE `eqs` to a MATLAB function handle `Jfun` that returns a pair of Jacobian matrices evaluated at the given point `(t, y0, yp0)`: the first one is the Jacobian of `eqs` differentiated by `vars` and the second one is that of by `diff(vars)`.
The returned function handle `Jfun` is acceptable as a value of the `jacobian` option in `odeset` for `ode15i`.
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
[Jy, Jyp] = Jfun(0, [2; 3], [4; 5], 6, 7) % a<-6, b<-7
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
tf = isLowIndex(eqs, vars)
```

### Description
`tf = isLowIndex(eqs, vars)` returns `true` if a DAE `eqs` is of low differential index (0 or 1). This function can be applied to higher-order DAEs.

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
S = orderMatrix(eqs, vars)
```

### Description
`S = orderMatrix(eqs, vars)` returns a matrix whose `(i, j)`th entry contains the maximum `k` such that `eqs(i)` depends on the `k`th order time derivative of `vars(j)`. If `eqs(i)` does not depend on any derivative of `vars(j)`, the entry is set to `-Inf`.

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

## preprocessDAE

### Syntax
```matlab
[newEqs, newVars] = preprocessDAE(eqs, vars)
[newEqs, newVars, degreeOfFreedom] = preprocessDAE(eqs, vars)
[newEqs, newVars, degreeOfFreedom, R] = preprocessDAE(eqs, vars, 'Method', 'augmentation')
[newEqs, newVars, degreeOfFreedom, R, constR] = preprocessDAE(eqs, vars, 'Method', 'augmentation', 'Constants', 'sym')
```

### Description
* `[newEqs, newVars] = preprocessDAE(eqs, vars)` converts a DAE `eqs` into an equivalent DAE `newEqs` to which [`reduceIndex`](#reduceIndex) can be applied.
* `[newEqs, newVars, degreeOfFreedom] = preprocessDAE(eqs, vars)` returns the degree of freedom of DAE's solutions, which is the dimension of the solution manifold.
* `[newEqs, newVars, degreeOfFreedom, R] = preprocessDAE(eqs, vars, 'Method', 'augmentation')` returns a matrix `R` that expresses the new variables in `newVars` as derivatives of the original variables `vars`.
* `[newEqs, newVars, degreeOfFreedom, R, constR] = preprocessDAE(eqs, vars, 'Method', 'augmentation', 'Constants', 'sym')` returns a matrix `constR` that expresses the constants as derivatives of the original variables `vars`.

### Options

|Option      |Description                       |Possible Values  |
|------------|----------------------------------|-----------------|
|`Method`    |Designate a modification method. The substitution method retains the size of the DAE system but is inapplicable to some DAEs. The augmentation method enlarges the system by introducing new variables and constants but is applicable to almost DAEs. |`substitution` (default) or `augmentation` |
|`Constants` |Designate how constants introduced in the augmentation method should be treated. If `Constants` is `zero`, 0 is plugged in for all the constants. If `Constants` is `sym`, symbolic objects representing the constants are substituted. |`zero` (default) or `sym` |

### Examples

```matlab
syms x(t) y(t)
vars = [x, y];
eqs = [
    -diff(x(t), t, 2)        - y(t) == sin(t)
     diff(x(t), t, 2) + x(t) + y(t) == t
];
[newEqs, newVars, degreeOfFreedom] = preprocessDAE(eqs, vars)
```
> ```
> newEqs =
> 
>                   x(t) - sin(t) - t
>  x(t) - t + y(t) + diff(x(t), t, t)
> 
> 
> newVars =
> 
>  x(t)
>  y(t)
>
> degreeOfFreedom =
> 
>      0
> ```

```matlab
syms x(t) y(t)
vars = [x, y];
eqs = [
    -diff(x(t), t, 2)        - y(t) == sin(t)
     diff(x(t), t, 2) + x(t) + y(t) == t
];
[newEqs, newVars, degreeOfFreedom, R] = preprocessDAE(eqs, vars, 'Method', 'augmentation')
```
> ```
> newEqs =
> 
>                  - Dxtt(t) - sin(t)
>  x(t) - t + y(t) + diff(x(t), t, t)
>                  Dxtt(t) - t + x(t)
> 
> 
> newVars =
> 
>     x(t)
>     y(t)
>  Dxtt(t)
> 
> 
> degreeOfFreedom =
> 
>      0
> 
> 
> R =
> 
> [ Dxtt(t), diff(x(t), t, t)]
> ```

```matlab
syms x(t) y(t)
vars = [x, y];
eqs = [
    -diff(x(t), t, 2)        - y(t) == sin(t)
     diff(x(t), t, 2) + x(t) + y(t) == t
];
[newEqs, newVars, degreeOfFreedom, R, constR] = preprocessDAE(eqs, vars, 'Method', 'augmentation', 'Constants', 'sym')
```
> ```
> newEqs =
> 
>         - consty - Dxtt(t) - sin(t)
>  x(t) - t + y(t) + diff(x(t), t, t)
>         consty - t + Dxtt(t) + x(t)
> 
> 
> newVars =
> 
>     x(t)
>     y(t)
>  Dxtt(t)
> 
> 
> degreeOfFreedom =
> 
>      0
> 
> 
> R =
> 
> [ Dxtt(t), diff(x(t), t, t)]
> 
> 
> constR =
> 
> [ consty, y(t)]
> ```

## reduceIndex

### Syntax
```matlab
[newEqs, newVars] = reduceIndex(eqs, vars)
[newEqs, newVars, R] = reduceIndex(eqs, vars)
```

### Description
* `[newEqs, newVars] = reduceIndex(eqs, vars)` converts a DAE `eqs` to an equivalent DAE `newEqs` of index at most 1 using the Mattsson−Söderlind method (MS-method). 
If a given DAE does not satisfy the validity condition of the MS-method, this function outputs an error.
In this case, modify the DAE using [`preprocessDAE`](#preprocessDAE) beforehand.
The function `reduceIndex` can be applied to higher-order DAEs.
* `[newEqs, newVars, R] = reduceIndex(eqs, vars)` returns a matrix `R` that expresses the new variables in `newVars` as derivatives of the original variables `vars`.

### Examples

```matlab
syms y(t) z(t) T(t) g
eqs = [
    diff(y(t), 2) == y(t)*T(t)
    diff(z(t), 2) == z(t)*T(t) - g
    y(t)^2 + z(t)^2 == 1
];
vars = [y, z, T];
[newEqs, newVars, R] = reduceIndex(eqs, vars)
```

> ```
> newEqs =
> 
>                                                        Dytt(t) - T(t)*y(t)
>                                           diff(z(t), t, t) + g - T(t)*z(t)
>                                                        y(t)^2 + z(t)^2 - 1
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
J = systemJacobian(eqs, vars)
```

### Description

`J = systemJacobian(eqs, vars)` returns the system Jacobian matrix of a DAE `eqs` with respect to `vars`. The `(i, j)`th entry of the resulting matrix is the derivative of `eqs(i)^(p(i))` by `vars(j)^(q(j))`, where `p` and `q` are a dual optimal solution of the assignment problem obtained from the order matrix of the DAE system
(here, `x^k` means the `k`th-order time derivative `d^k x(t)/dt^k` of `x(t)`).
`reduceIndex` can be applied to a DAE system only if its system Jacobian is nonsingular.

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
