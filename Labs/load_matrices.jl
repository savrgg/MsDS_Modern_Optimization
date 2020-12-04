function ReadLIBSVM(fname::ASCIIString, shape, classification::Bool)
    b = zeros(shape[1])
    Ir = int(zeros(shape[1]*shape[2]))
    Jr = int(zeros(shape[1]*shape[2]))
    Pr = zeros(shape[1]*shape[2])
    fi = open("$fname", "r")
    n = 1
    cnt = 1
    for line in eachline(fi)
        line = split(line, " ")
        b[n] = float(line[1])
        line = line[2:end]
        for itm in line
            itm = split(itm, ":")
            Ir[cnt] = n
            try
                Jr[cnt] = int(itm[1])
            catch
                continue
            end
            try
                Pr[cnt] = float(strip(itm[2]))
            catch
                print(itm[2])
            end
            cnt += 1
         end
         n += 1
    end
    close(fi)

    if classification
        mb = mean(b)
        for i=1:length(b)
            b[i] = (b[i] > mb)? 1. : -1.
        end
    end
    
    Ir = Ir[1:cnt-1]
    Jr = Jr[1:cnt-1]
    Pr = Pr[1:cnt-1]

    A = sparse(int(Ir), int(Jr), Pr, shape[1], shape[2])
    b = squeeze(b, 2)

    if size(A)[1] == length(b)
        A = A'
    end

    A = sparse([ones(1,size(A)[2]),A])
    
  return A,b
end

function ReadData(whichdata::ASCIIString, classification)
    M = readdlm("matrix_$whichdata.txt")
    n = M[1]
    m = M[2]
    nnz = M[3]
    Jc = M[4:4+n+1-1]
    Ir = M[4+n+1:4+n+nnz]
    Pr = M[4+n+nnz+1:4+n+2nnz]
    Jr = zeros(length(Ir))

    for j=1:n
        Jr[Jc[j]+1:Jc[j+1]]=j
    end
    Ir += 1

    b = readdlm("vector_$whichdata.txt")

    if classification
        mb = mean(b)
        for i=1:length(b)
            b[i] = (b[i] > mb)? 1. : -1.
        end
    end

    A = sparse(int(Ir), int(Jr), Pr, m, n)
    b = squeeze(b, 2)

    if size(A)[1] == length(b)
        A = A'
    end

    return A,squeeze(b,2)
end