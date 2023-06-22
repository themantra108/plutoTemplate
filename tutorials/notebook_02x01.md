~~~
<!-- PlutoStaticHTML.Begin -->
<!--
    # This information is used for caching.
    [PlutoStaticHTML.State]
    input_sha = "4b6a026e88ac7b1670387280e5ba66b6ce173153fe0877ae6e01140d5c9af68d"
    julia_version = "1.9.1"
-->
<pre class='language-julia'><code class='language-julia'>using DataFrames, CSV, MLJ, MLJDecisionTreeInterface</code></pre>


<pre class='language-julia'><code class='language-julia'>X_full = CSV.read("data//home-data-for-ml-course//train.csv", DataFrame);</code></pre>


<pre class='language-julia'><code class='language-julia'>X_test_full = CSV.read("data//home-data-for-ml-course//test.csv", DataFrame);</code></pre>


<pre class='language-julia'><code class='language-julia'>y = X_full.SalePrice;</code></pre>


<pre class='language-julia'><code class='language-julia'>features = [:LotArea, :YearBuilt, Symbol("1stFlrSF"), Symbol("2ndFlrSF"), :FullBath, :BedroomAbvGr, :TotRmsAbvGrd];</code></pre>


<pre class='language-julia'><code class='language-julia'>X = copy(X_full[:,features]);</code></pre>


<pre class='language-julia'><code class='language-julia'>X_test = copy(X_test_full[:,features]);</code></pre>


<pre class='language-julia'><code class='language-julia'>(X_train, X_valid), (y_train, y_valid) = partition((X, y), 0.8, multi=true)</code></pre>
<pre class="code-output documenter-example-output" id="var-y_valid">((1168×7 DataFrame
  Row │ LotArea  YearBuilt  1stFlrSF  2ndFlrSF  FullBath  BedroomAbvGr  TotRmsAbvGrd
      │ Int64    Int64      Int64     Int64     Int64     Int64         Int64
──────┼──────────────────────────────────────────────────────────────────────────────
    1 │    8450       2003       856       854         2             3             8
    2 │    9600       1976      1262         0         2             3             6
    3 │   11250       2001       920       866         2             3             6
    4 │    9550       1915       961       756         1             3             7
    5 │   14260       2000      1145      1053         2             4             9
  ⋮   │    ⋮         ⋮         ⋮         ⋮         ⋮           ⋮             ⋮
 1165 │   16157       1978      1432         0         1             2             5
 1166 │    9541       2009      1502         0         2             3             7
 1167 │   10475       2008      1694         0         2             3             7
 1168 │   10852       2000       959       712         2             3             7
                                                                    1159 rows omitted, 292×7 DataFrame
 Row │ LotArea  YearBuilt  1stFlrSF  2ndFlrSF  FullBath  BedroomAbvGr  TotRmsAbvGrd
     │ Int64    Int64      Int64     Int64     Int64     Int64         Int64
─────┼──────────────────────────────────────────────────────────────────────────────
   1 │   13728       1935      1236       872         2             4             7
   2 │   35760       1995      1831      1796         3             4            10
   3 │    9880       1977      1118         0         1             3             6
   4 │    9120       1958      1261         0         1             3             6
   5 │    4017       2006       625       625         2             2             5
  ⋮  │    ⋮         ⋮         ⋮         ⋮         ⋮           ⋮             ⋮
 289 │   13175       1978      2073         0         2             3             7
 290 │    9042       1941      1188      1152         2             4             9
 291 │    9717       1950      1078         0         1             2             5
 292 │    9937       1965      1256         0         1             3             6
                                                                    283 rows omitted), ([208500, 181500, 223500, 140000, 250000, 143000, 307000, 200000, 129900, 118000  …  235128, 185000, 146000, 224000, 129000, 108959, 194000, 233170, 245350, 173000], [235000, 625000, 171000, 163000, 171900, 200500, 239000, 285000, 119500, 115000  …  136000, 287090, 145000, 84500, 185000, 175000, 210000, 266500, 142125, 147500]))</pre>

<pre class='language-julia'><code class='language-julia'>Forest = @load RandomForestRegressor pkg=DecisionTree verbosity = 0</code></pre>
<pre class="code-output documenter-example-output" id="var-Forest">RandomForestRegressor</pre>

<pre class='language-julia'><code class='language-julia'>model_1 = Forest(n_trees=50, rng=0);</code></pre>


<pre class='language-julia'><code class='language-julia'>model_2 = Forest(n_trees=100, rng=0);</code></pre>


<pre class='language-julia'><code class='language-julia'>model_3 = Forest(n_trees=100, feature_importance= :split, rng=0);</code></pre>


<pre class='language-julia'><code class='language-julia'>model_4 = Forest(n_trees=200, min_samples_split=20, rng=0);</code></pre>


<pre class='language-julia'><code class='language-julia'>model_5 = Forest(n_trees=100, max_depth=7, rng=0); </code></pre>


<pre class='language-julia'><code class='language-julia'>models = [model_1, model_2, model_3, model_4, model_5];</code></pre>


<pre class='language-julia'><code class='language-julia'>function score_model(model; X_t = X_train, X_v = X_valid, y_t = y_train, y_v = y_valid)
    mach = machine(model, X_t, y_t, scitype_check_level=0)
    fit!(mach, verbosity=0)
    preds = predict(mach, X_v)
    return mean_absolute_error(preds, y_v)
end</code></pre>
<pre class="code-output documenter-example-output" id="var-score_model">score_model (generic function with 1 method)</pre>

<pre class='language-julia'><code class='language-julia'>for i in 1:length(models)
    mae = score_model(models[i])
    println("Model $(i) MAE: $(mae)")
end</code></pre>


<pre class='language-julia'><code class='language-julia'>best_model = model_3;</code></pre>


<pre class='language-julia'><code class='language-julia'>my_model = machine(best_model, X, y, scitype_check_level=0);</code></pre>


<pre class='language-julia'><code class='language-julia'>fit!(my_model)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash126609">trained Machine; caches model-specific representations of data
  model: RandomForestRegressor(max_depth = -1, …)
  args: 
    1:	Source @493 ⏎ ScientificTypesBase.Table{AbstractVector{ScientificTypesBase.Count}}
    2:	Source @846 ⏎ AbstractVector{ScientificTypesBase.Count}
</pre>

<pre class='language-julia'><code class='language-julia'>preds_test = predict(my_model, X_test)</code></pre>
<pre class="code-output documenter-example-output" id="var-preds_test">1459-element Vector{Float64}:
 123619.0
 154524.0
 186848.0
 180457.0
 184994.48
 200124.7
 173519.0
      ⋮
  88614.0
  86494.0
  86165.0
 153198.28
 135044.5
 232758.22</pre>

<pre class='language-julia'><code class='language-julia'>output = DataFrame("Id" =&gt; X_test_full.Id,
                       "SalePrice" =&gt; preds_test)</code></pre>
<table><tbody><tr><th></th><th>Id</th><th>SalePrice</th></tr><tr><td>1</td><td>1461</td><td>123619.0</td></tr><tr><td>2</td><td>1462</td><td>154524.0</td></tr><tr><td>3</td><td>1463</td><td>186848.0</td></tr><tr><td>4</td><td>1464</td><td>180457.0</td></tr><tr><td>5</td><td>1465</td><td>1.84994e5</td></tr><tr><td>6</td><td>1466</td><td>2.00125e5</td></tr><tr><td>7</td><td>1467</td><td>173519.0</td></tr><tr><td>8</td><td>1468</td><td>1.74786e5</td></tr><tr><td>9</td><td>1469</td><td>186665.0</td></tr><tr><td>10</td><td>1470</td><td>1.18057e5</td></tr><tr><td>...</td></tr><tr><td>1459</td><td>2919</td><td>2.32758e5</td></tr></tbody></table>

<pre class='language-julia'><code class='language-julia'>CSV.write("data//home-data-for-ml-course//submissions_02x01.csv", output)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash183454">"data//home-data-for-ml-course//submissions_02x01.csv"</pre>
<div class='manifest-versions'>
<p>Built with Julia 1.9.1 and</p>
CSV 0.10.11<br>
DataFrames 1.5.0<br>
MLJ 0.19.2<br>
MLJDecisionTreeInterface 0.4.0
</div>

<!-- PlutoStaticHTML.End -->
~~~