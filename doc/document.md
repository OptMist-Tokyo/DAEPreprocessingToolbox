Document
====

* [isLowIndex](#isLowIndex) : check if a DAE is of low index (0 or 1).
* [orderMatrix](#orderMatrix) : matrix storing differential orders of variables in DAE system.
* [systemJacobian](#systemJacobian) : system Jacobian matrix of DAE system.

## isLowIndex
### Format
```matlab
isLowIndex(F, x)
```
* `F` : vector of equations
* `x` : vector of variables

### Description
Return `true` if the DAE is of low differential index (0 or 1). This function can be applied to DAEs with higher order derivatives.

### Example
```matlab
syms x(t) y(t)
isLowIndex([x(t)*y(t), diff(x(t))+diff(y(t))], [x, y])
```
> ```
> true
> ```

```matlab
syms x(t) y(t)
isLowIndex([diff(x(t),2)+y(t), diff(x(t),2)+x(t)+y(t)], [x, y])
```
> ```
> false
> ```


## orderMatrix

### Format
```matlab
orderMatrix(F, x)
```
* `F` : vector of equations
* `x` : vector of variables

### Description
Return a matrix whose `(i,j)`th entry contains the maximum `k` such that `eqs(i)` depends on the `k`th order derivative of `vars(j)`. If `eqs(i)` does not depend on any derivative of `vars(j)`, the entry is set to `-Inf`.

### Example
```matlab
syms x(t) y(t)
orderMatrix([x(t)*y(t), diff(x(t))+diff(y(t))], [x, y])
```
> ```
> [0, 0; 1, 1]
> ```

## systemJacobian

### Format
```matlab
systemJacobian(F, x)
```
* `F` : vector of equations
* `x` : vector of variables

### Description

Return the system Jacobian matrix of the vector `eqs` with respect to the vector `vars`. The `(i,j)`th entry of the resulting matrix is the derivative of `eqs(i)^(p(i))` by `vars(j)^(q(j))`, where `p` and `q` are a dual optimal solution of the assignment problem obtained from the order matrix of the DAE system.

### Example
```matlab
syms x(t) y(t)
systemJacobian([x(t)*y(t), diff(x(t))+diff(y(t))], [x, y])
```

> ```
> [y(t), x(t); 1, 1]
> ```
