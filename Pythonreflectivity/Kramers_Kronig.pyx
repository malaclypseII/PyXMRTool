

cdef double KKT_Onepoint(  int j,  double *e,  double *im, int Lred ):
    cdef double a,b,c,sum1
    cdef double s1, s2, s3, s4, s5
    cdef double e0=e[0]
    cdef double ej=e[j]
    cdef int iplus
    sum1=0
    s2=(ej+e0)
    s3=e0*im[0]
    s5=(ej-e0)
    b=s3/s2
    for i in range(Lred):
        iplus=i+1
        s1=(e[iplus]-e[i])
        c=b
        s3=e[iplus]*im[iplus]
        s2=(ej+e[iplus])
        b=s3/s2
        a=( b - c)/s1
        sum1=sum1+a*s1
        s4=s5
        s5=(ej-e[iplus])
        if(j==iplus ):
            sum1-=(a*s4+ c )*log( dabsvalue(s4  ))
        elif( j==i ):
            sum1+=(a*s4+ c )*log( dabsvalue(s5 ))
        else:
            sum1+=(a*s4+ c )*log( dabsvalue( s5/s4 ) )

    sum1*=0.6366197723675814
    return sum1




cdef void Kramers_Kronig_Transformation_internal( ndarray[double, ndim=1, mode="c"] e, \
                                         ndarray[double, ndim=1, mode="c"] im,
                                         ndarray[double, ndim=1, mode="c"] re, int L):
    cdef int Lred=L-1
    cdef double *repointer= <double*> re.data
    cdef double *impointer=<double*> im.data
    cdef double *epointer =<double*> e.data

    for j in range(L):
        repointer[j]=KKT_Onepoint( j, epointer, impointer, Lred )

