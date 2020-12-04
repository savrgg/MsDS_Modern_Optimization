function PTCreate(L::Array{Float64,1})
  n = length(L)
  m = ceil(Int, log2(n))
  P = zeros(2^(m+1) - 1)
  for i=1:n
    P[i] = L[i]
  end
  start = 2^m
  start_last = 0
  for k=1:m
    for i=1:2^(m-k)
      P[start + i] = P[start_last + 2i - 1] + P[start_last + 2i]
    end
    start_last = start
    start += 2^(m-k)
  end
  return P
end

function PTSample(ProbTree::Array{Float64,1})
  m = convert(Int, log2(length(ProbTree) + 1) - 1)
  i = 1
  start = 2^(m+1)-2
  for k=1:m
    start_last = start - 2^k
    i = (ProbTree[start+i]*rand() < ProbTree[start_last + 2i - 1])? 2i-1 : 2i
    start = start_last
  end
  return i
end

function PTUpdate(ProbTree::Array{Float64,1}, Ind::Int64, NewValue::Float64)
  ProbTree[Ind] = NewValue
  m = convert(Int,log2(length(ProbTree)+1)-1)
  start_last = 0
  start = 2^m
  for k=1:m
    Ind = ceil(Int, Ind/2)
    ProbTree[start + Ind] = ProbTree[start_last + 2Ind] + ProbTree[start_last + 2Ind - 1]
    start_last = start
    start += 2^(m-k)
  end
  return ProbTree
end


