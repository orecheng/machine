for i in range(5000):
    for j in range(5000):
        a[i,j,0] = a[i,j,1];
        a[i,j,2] = a[i,j,0];
        a[i,j,1] = a[i,j,2];