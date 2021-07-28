function rv = COBYLA( func, x0, constraints, rho_start, rho_end
    % initialize
    rho = rho_start;
    mu = 0;
    Star = true;
    Delta = false;
    branch = Star;
    ON = true;
    OFF = false;
    flag = ON;
    x0 = x0(:); % column
    nfe = 0;
    y0 = func(x0);
    nfe = nfe + 1;
    n = length(x0);
    m = length(constraints);
    x_simplex = NaN(n, n+1);
    x_simplex(:,1) = x0;
    y_simplex = NaN(1,(n+1));
    y_simplex(1) = y0;
    alpha = 0.25;
    beta = 2.1;
    for i = 1:n
        c = x0;
        x_simplex(i,i+1) = x0(i) + rho;
        y_simplex(i) = func(x_simplex(:,i+1));
        nfe = nfe + 1;
    end
    
    % main loop
    % ensure x0 is optimal vertex
    [ybest, i] = min(y_simplex);
    tmp = x_simplex(:,1);
    x_simplex(:,1) = x_simplex(:,i);
    x_simplex(:,i) = tmp;
    tmp = y_simplex(1);
    y_simplex(1) = y_simplex(i);
    y_simplex(i) = tmp;
    % ensure simplex is acceptable
    flag = IsAcceptableSimplex(x_simplex, rho, alpha, beta);
    if branch || flag
        % main branch
    else
        % delta branch: revise simplex to make it acceptable
    end
    
end

function rv = IsAcceptableSimplex( x, rho, alpha, beta )
    n = size(x, 1);
    CM = CayleyMengerMatrix(x);
    V = SimplexHyperVolume(CM);
    Ai = zeros(1,n+1); % areas of facets
    hi = zeros(1,n+1); % heights from opposite vertex
    for i = 1:(n+1) % Powell: 2:n, not 1:n, Eq (14)
        idx = [1:(i-1),(i+1):(n+2)]; % all indices except i
        iCM = CM(idx,idx); % submatrix
        Ai(i) = SimplexHyperVolume( iCM );
        hi(i) = V / Ai(i);
    end
    ok = true;
    for i = 2:(n+1)
        if hi(i) < alpha * rho
            true = false;
            break
        end
        di = sqrt(CM(1,i));
        if di > beta * rho
            true = false;
            break;
        end
    end
    return ok;
end

function rv = CayleyMengerMatrix( x )
    n = size(x,1); % space dimension
    rv = zeros(n+2,n+2);
    rv(1:(end-1),n+2) = 1;
    rv(n+2,1:(end-1)) = 1;
    for i = 1:(n+1)
        for j = 1:(i-1)
            dp = x(:,i) - x(:,j);
            dij = dp' * dp;
            rv(i,j) = dij;
            rv(j,i) = dij;
        end
    end
end
    
function rv = SimplexHyperVolume( CM )
    n = size(CM,1) - 2;
    fac = (-1)^(n+1) / ( (factorial(n))^2  * 2^n);
    rv = sqrt(det(CM) * fac);
end
