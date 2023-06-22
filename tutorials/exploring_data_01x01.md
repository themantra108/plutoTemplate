~~~
<!-- PlutoStaticHTML.Begin -->
<!--
    # This information is used for caching.
    [PlutoStaticHTML.State]
    input_sha = "e7c57584e5701d28bc89479b2e8ee44ddda05c5abfcdb36c4e411ac7b243b8f1"
    julia_version = "1.9.1"
-->
<pre class='language-julia'><code class='language-julia'>using DataFrames, CSV, MLJ, MLJDecisionTreeInterface</code></pre>


<pre class='language-julia'><code class='language-julia'>using Statistics, Dates</code></pre>


<pre class='language-julia'><code class='language-julia'>iowa_file_path = "data//home-data-for-ml-course//train.csv"</code></pre>
<pre class="code-output documenter-example-output" id="var-iowa_file_path">"data//home-data-for-ml-course//train.csv"</pre>

<pre class='language-julia'><code class='language-julia'>home_data = CSV.read(iowa_file_path, DataFrame);</code></pre>


<pre class='language-julia'><code class='language-julia'>describe(home_data)</code></pre>
<table><tbody><tr><th></th><th>variable</th><th>mean</th><th>min</th><th>median</th><th>max</th><th>nmissing</th><th>eltype</th></tr><tr><td>1</td><td>:Id</td><td>730.5</td><td>1</td><td>730.5</td><td>1460</td><td>0</td><td>Int64</td></tr><tr><td>2</td><td>:MSSubClass</td><td>56.8973</td><td>20</td><td>50.0</td><td>190</td><td>0</td><td>Int64</td></tr><tr><td>3</td><td>:MSZoning</td><td>nothing</td><td>"C (all)"</td><td>nothing</td><td>"RM"</td><td>0</td><td>String7</td></tr><tr><td>4</td><td>:LotFrontage</td><td>nothing</td><td>"100"</td><td>nothing</td><td>"NA"</td><td>0</td><td>String3</td></tr><tr><td>5</td><td>:LotArea</td><td>10516.8</td><td>1300</td><td>9478.5</td><td>215245</td><td>0</td><td>Int64</td></tr><tr><td>6</td><td>:Street</td><td>nothing</td><td>"Grvl"</td><td>nothing</td><td>"Pave"</td><td>0</td><td>String7</td></tr><tr><td>7</td><td>:Alley</td><td>nothing</td><td>"Grvl"</td><td>nothing</td><td>"Pave"</td><td>0</td><td>String7</td></tr><tr><td>8</td><td>:LotShape</td><td>nothing</td><td>"IR1"</td><td>nothing</td><td>"Reg"</td><td>0</td><td>String3</td></tr><tr><td>9</td><td>:LandContour</td><td>nothing</td><td>"Bnk"</td><td>nothing</td><td>"Lvl"</td><td>0</td><td>String3</td></tr><tr><td>10</td><td>:Utilities</td><td>nothing</td><td>"AllPub"</td><td>nothing</td><td>"NoSeWa"</td><td>0</td><td>String7</td></tr><tr><td>...</td></tr><tr><td>81</td><td>:SalePrice</td><td>1.80921e5</td><td>34900</td><td>163000.0</td><td>755000</td><td>0</td><td>Int64</td></tr></tbody></table>


<pre class="code-output documenter-example-output" id="var-avg_lot_size">10517.0</pre>


<pre class="code-output documenter-example-output" id="var-newest_home_age">13</pre>

<pre class='language-julia'><code class='language-julia'>names(home_data)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash167845">81-element Vector{String}:
 "Id"
 "MSSubClass"
 "MSZoning"
 "LotFrontage"
 "LotArea"
 "Street"
 "Alley"
 ⋮
 "MiscVal"
 "MoSold"
 "YrSold"
 "SaleType"
 "SaleCondition"
 "SalePrice"</pre>

<pre class='language-julia'><code class='language-julia'>y = home_data.SalePrice;</code></pre>


<pre class='language-julia'><code class='language-julia'>feature_names = [:LotArea, :YearBuilt, Symbol("1stFlrSF"), Symbol("2ndFlrSF"), :FullBath, :BedroomAbvGr, :TotRmsAbvGrd];</code></pre>


<pre class='language-julia'><code class='language-julia'>X = home_data[:, feature_names];</code></pre>


<pre class='language-julia'><code class='language-julia'>describe(X)</code></pre>
<table><tbody><tr><th></th><th>variable</th><th>mean</th><th>min</th><th>median</th><th>max</th><th>nmissing</th><th>eltype</th></tr><tr><td>1</td><td>:LotArea</td><td>10516.8</td><td>1300</td><td>9478.5</td><td>215245</td><td>0</td><td>Int64</td></tr><tr><td>2</td><td>:YearBuilt</td><td>1971.27</td><td>1872</td><td>1973.0</td><td>2010</td><td>0</td><td>Int64</td></tr><tr><td>3</td><td>Symbol("1stFlrSF")</td><td>1162.63</td><td>334</td><td>1087.0</td><td>4692</td><td>0</td><td>Int64</td></tr><tr><td>4</td><td>Symbol("2ndFlrSF")</td><td>346.992</td><td>0</td><td>0.0</td><td>2065</td><td>0</td><td>Int64</td></tr><tr><td>5</td><td>:FullBath</td><td>1.56507</td><td>0</td><td>2.0</td><td>3</td><td>0</td><td>Int64</td></tr><tr><td>6</td><td>:BedroomAbvGr</td><td>2.86644</td><td>0</td><td>3.0</td><td>8</td><td>0</td><td>Int64</td></tr><tr><td>7</td><td>:TotRmsAbvGrd</td><td>6.51781</td><td>2</td><td>6.0</td><td>14</td><td>0</td><td>Int64</td></tr></tbody></table>

<pre class='language-julia'><code class='language-julia'>Tree = @load DecisionTreeRegressor pkg=DecisionTree verbosity=0</code></pre>
<pre class="code-output documenter-example-output" id="var-Tree">DecisionTreeRegressor</pre>

<pre class='language-julia'><code class='language-julia'>iowa_model = Tree(rng = 123)</code></pre>
<pre class="code-output documenter-example-output" id="var-iowa_model">DecisionTreeRegressor(
  max_depth = -1, 
  min_samples_leaf = 5, 
  min_samples_split = 2, 
  min_purity_increase = 0.0, 
  n_subfeatures = 0, 
  post_prune = false, 
  merge_purity_threshold = 1.0, 
  feature_importance = :impurity, 
  rng = 123)</pre>

<pre class='language-julia'><code class='language-julia'>mach = machine(iowa_model, X, y, scitype_check_level=0)</code></pre>
<pre class="code-output documenter-example-output" id="var-mach">untrained Machine; caches model-specific representations of data
  model: DecisionTreeRegressor(max_depth = -1, …)
  args: 
    1:	Source @890 ⏎ ScientificTypesBase.Table{AbstractVector{ScientificTypesBase.Count}}
    2:	Source @450 ⏎ AbstractVector{ScientificTypesBase.Count}
</pre>

<pre class='language-julia'><code class='language-julia'>fit!(mach)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash928816">trained Machine; caches model-specific representations of data
  model: DecisionTreeRegressor(max_depth = -1, …)
  args: 
    1:	Source @890 ⏎ ScientificTypesBase.Table{AbstractVector{ScientificTypesBase.Count}}
    2:	Source @450 ⏎ AbstractVector{ScientificTypesBase.Count}
</pre>

<pre class='language-julia'><code class='language-julia'>predictions = predict(mach, X)</code></pre>
<pre class="code-output documenter-example-output" id="var-predictions">1460-element Vector{Float64}:
 212000.0
 163600.0
 207066.66666666666
 127600.0
 264816.6666666667
 140375.0
 264580.0
      ⋮
 182591.42857142858
 175700.0
 225066.66666666666
 256480.0
 133045.0
 154485.7142857143</pre>

<pre class='language-julia'><code class='language-julia'>DataFrame("predictions"=&gt; round.(Int,predictions), "y" =&gt; y)</code></pre>
<table><tbody><tr><th></th><th>predictions</th><th>y</th></tr><tr><td>1</td><td>212000</td><td>208500</td></tr><tr><td>2</td><td>163600</td><td>181500</td></tr><tr><td>3</td><td>207067</td><td>223500</td></tr><tr><td>4</td><td>127600</td><td>140000</td></tr><tr><td>5</td><td>264817</td><td>250000</td></tr><tr><td>6</td><td>140375</td><td>143000</td></tr><tr><td>7</td><td>264580</td><td>307000</td></tr><tr><td>8</td><td>198567</td><td>200000</td></tr><tr><td>9</td><td>112329</td><td>129900</td></tr><tr><td>10</td><td>129650</td><td>118000</td></tr><tr><td>...</td></tr><tr><td>1460</td><td>154486</td><td>147500</td></tr></tbody></table>

<pre class='language-julia'><code class='language-julia'>begin
    println("First in-sample predictions:", predictions[1:5])
    println("Actual target values for those homes:", y[1:5])
end</code></pre>


<pre class='language-julia'><code class='language-julia'>mean_absolute_error(predictions,y)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash288547">16686.449680908874</pre>

<pre class='language-julia'><code class='language-julia'>(Xtrain, Xtest), (ytrain, ytest) = partition((X, y), 0.8, rng=123, multi=true)</code></pre>
<pre class="code-output documenter-example-output" id="var-Xtrain">((1168×7 DataFrame
  Row │ LotArea  YearBuilt  1stFlrSF  2ndFlrSF  FullBath  BedroomAbvGr  TotRmsAbvGrd
      │ Int64    Int64      Int64     Int64     Int64     Int64         Int64
──────┼──────────────────────────────────────────────────────────────────────────────
    1 │   15865       1970      2217         0         2             4             8
    2 │    9920       1969       971         0         1             3             5
    3 │    8963       1976      1175      1540         3             4            11
    4 │    7094       1966       894         0         1             3             5
    5 │   10530       1971       981         0         1             3             5
  ⋮   │    ⋮         ⋮         ⋮         ⋮         ⋮           ⋮             ⋮
 1165 │    8125       2006       778       798         2             3             6
 1166 │    8250       1964      1092         0         1             3             6
 1167 │    7082       1916       948       980         2             5            10
 1168 │   11160       1968      2110         0         2             3             8
                                                                    1159 rows omitted, 292×7 DataFrame
 Row │ LotArea  YearBuilt  1stFlrSF  2ndFlrSF  FullBath  BedroomAbvGr  TotRmsAbvGrd
     │ Int64    Int64      Int64     Int64     Int64     Int64         Int64
─────┼──────────────────────────────────────────────────────────────────────────────
   1 │    9947       1990      1217         0         2             3             6
   2 │    8712       1957      1306         0         1             2             5
   3 │   14191       2002       993       915         2             4             9
   4 │   39104       1954      1363         0         1             2             5
   5 │   10678       1992      2129       743         2             4             9
  ⋮  │    ⋮         ⋮         ⋮         ⋮         ⋮           ⋮             ⋮
 289 │   17503       1948       912       546         1             3             6
 290 │    4270       1931       774         0         1             3             6
 291 │   11228       1993      1080      1017         2             3             9
 292 │   19296       1962      1382         0         1             3             6
                                                                    283 rows omitted), ([268000, 128500, 299800, 125000, 143250, 134900, 110000, 170000, 176500, 154000  …  240000, 135000, 140000, 222000, 235000, 302000, 197000, 145000, 160000, 244000], [173000, 153000, 202900, 241500, 285000, 354000, 237000, 152000, 108000, 140000  …  180000, 223000, 130500, 175000, 156500, 140000, 97500, 79000, 228000, 176000]))</pre>

<pre class='language-julia'><code class='language-julia'>iowa_model1 = Tree(rng = 123)</code></pre>
<pre class="code-output documenter-example-output" id="var-iowa_model1">DecisionTreeRegressor(
  max_depth = -1, 
  min_samples_leaf = 5, 
  min_samples_split = 2, 
  min_purity_increase = 0.0, 
  n_subfeatures = 0, 
  post_prune = false, 
  merge_purity_threshold = 1.0, 
  feature_importance = :impurity, 
  rng = 123)</pre>

<pre class='language-julia'><code class='language-julia'>mach1 = machine(iowa_model1, Xtrain, ytrain, scitype_check_level=0)</code></pre>
<pre class="code-output documenter-example-output" id="var-mach1">untrained Machine; caches model-specific representations of data
  model: DecisionTreeRegressor(max_depth = -1, …)
  args: 
    1:	Source @162 ⏎ ScientificTypesBase.Table{AbstractVector{ScientificTypesBase.Count}}
    2:	Source @231 ⏎ AbstractVector{ScientificTypesBase.Count}
</pre>

<pre class='language-julia'><code class='language-julia'>fit!(mach1)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash156311">trained Machine; caches model-specific representations of data
  model: DecisionTreeRegressor(max_depth = -1, …)
  args: 
    1:	Source @162 ⏎ ScientificTypesBase.Table{AbstractVector{ScientificTypesBase.Count}}
    2:	Source @231 ⏎ AbstractVector{ScientificTypesBase.Count}
</pre>

<pre class='language-julia'><code class='language-julia'>val_predictions = predict(mach1, Xtest)</code></pre>
<pre class="code-output documenter-example-output" id="var-val_predictions">292-element Vector{Float64}:
 182000.0
 136500.0
 244698.88888888888
 147570.22222222222
 369939.6
 302241.4285714286
 244698.88888888888
      ⋮
 157044.44444444444
 136935.0
 143812.5
  64757.142857142855
 244500.0
 147570.22222222222</pre>

<pre class='language-julia'><code class='language-julia'>DataFrame("val_predictions"=&gt; round.(Int,val_predictions[1:5]), "val_y" =&gt; ytest[1:5])</code></pre>
<table><tbody><tr><th></th><th>val_predictions</th><th>val_y</th></tr><tr><td>1</td><td>182000</td><td>173000</td></tr><tr><td>2</td><td>136500</td><td>153000</td></tr><tr><td>3</td><td>244699</td><td>202900</td></tr><tr><td>4</td><td>147570</td><td>241500</td></tr><tr><td>5</td><td>369940</td><td>285000</td></tr></tbody></table>

<pre class='language-julia'><code class='language-julia'>mean_absolute_error(val_predictions, ytest)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash305816">26826.471499238956</pre>
<div class='manifest-versions'>
<p>Built with Julia 1.9.1 and</p>
CSV 0.10.9<br>
DataFrames 1.5.0<br>
MLJ 0.19.1<br>
MLJDecisionTreeInterface 0.4.0<br>
Statistics 1.9.0
</div>

<!-- PlutoStaticHTML.End -->
~~~