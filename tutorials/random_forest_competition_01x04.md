~~~
<!-- PlutoStaticHTML.Begin -->
<!--
    # This information is used for caching.
    [PlutoStaticHTML.State]
    input_sha = "1c836d6705241cbc9141954a12860e248359d79b0c1a51cf37f4931c5b8f06ae"
    julia_version = "1.9.1"
-->
<pre class='language-julia'><code class='language-julia'>using DataFrames, CSV, MLJ, MLJDecisionTreeInterface</code></pre>


<pre class='language-julia'><code class='language-julia'>begin
    iowa_file_path = "data//home-data-for-ml-course//train.csv"
    home_data = CSV.read(iowa_file_path, DataFrame)
    y = home_data.SalePrice
    feature_names = [:LotArea, :YearBuilt, Symbol("1stFlrSF"), Symbol("2ndFlrSF"), :FullBath, :BedroomAbvGr, :TotRmsAbvGrd]
    X = home_data[:, feature_names]
end</code></pre>
<table><tbody><tr><th></th><th>LotArea</th><th>YearBuilt</th><th>1stFlrSF</th><th>2ndFlrSF</th><th>FullBath</th><th>BedroomAbvGr</th><th>TotRmsAbvGrd</th></tr><tr><td>1</td><td>8450</td><td>2003</td><td>856</td><td>854</td><td>2</td><td>3</td><td>8</td></tr><tr><td>2</td><td>9600</td><td>1976</td><td>1262</td><td>0</td><td>2</td><td>3</td><td>6</td></tr><tr><td>3</td><td>11250</td><td>2001</td><td>920</td><td>866</td><td>2</td><td>3</td><td>6</td></tr><tr><td>4</td><td>9550</td><td>1915</td><td>961</td><td>756</td><td>1</td><td>3</td><td>7</td></tr><tr><td>5</td><td>14260</td><td>2000</td><td>1145</td><td>1053</td><td>2</td><td>4</td><td>9</td></tr><tr><td>6</td><td>14115</td><td>1993</td><td>796</td><td>566</td><td>1</td><td>1</td><td>5</td></tr><tr><td>7</td><td>10084</td><td>2004</td><td>1694</td><td>0</td><td>2</td><td>3</td><td>7</td></tr><tr><td>8</td><td>10382</td><td>1973</td><td>1107</td><td>983</td><td>2</td><td>3</td><td>7</td></tr><tr><td>9</td><td>6120</td><td>1931</td><td>1022</td><td>752</td><td>2</td><td>2</td><td>8</td></tr><tr><td>10</td><td>7420</td><td>1939</td><td>1077</td><td>0</td><td>1</td><td>2</td><td>5</td></tr><tr><td>...</td></tr><tr><td>1460</td><td>9937</td><td>1965</td><td>1256</td><td>0</td><td>1</td><td>3</td><td>6</td></tr></tbody></table>

<pre class='language-julia'><code class='language-julia'>Forest = @load RandomForestRegressor pkg=DecisionTree verbosity=0</code></pre>
<pre class="code-output documenter-example-output" id="var-Forest">RandomForestRegressor</pre>

<pre class='language-julia'><code class='language-julia'>forest = Forest()</code></pre>
<pre class="code-output documenter-example-output" id="var-forest">RandomForestRegressor(
  max_depth = -1, 
  min_samples_leaf = 1, 
  min_samples_split = 2, 
  min_purity_increase = 0.0, 
  n_subfeatures = -1, 
  n_trees = 100, 
  sampling_fraction = 0.7, 
  feature_importance = :impurity, 
  rng = Random._GLOBAL_RNG())</pre>

<pre class='language-julia'><code class='language-julia'>mach = machine(forest, X, y, scitype_check_level=0)</code></pre>
<pre class="code-output documenter-example-output" id="var-mach">untrained Machine; caches model-specific representations of data
  model: RandomForestRegressor(max_depth = -1, …)
  args: 
    1:	Source @358 ⏎ ScientificTypesBase.Table{AbstractVector{ScientificTypesBase.Count}}
    2:	Source @253 ⏎ AbstractVector{ScientificTypesBase.Count}
</pre>

<pre class='language-julia'><code class='language-julia'>fit!(mach)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash928816">trained Machine; caches model-specific representations of data
  model: RandomForestRegressor(max_depth = -1, …)
  args: 
    1:	Source @358 ⏎ ScientificTypesBase.Table{AbstractVector{ScientificTypesBase.Count}}
    2:	Source @253 ⏎ AbstractVector{ScientificTypesBase.Count}
</pre>

<pre class='language-julia'><code class='language-julia'>test_data_path = "data//home-data-for-ml-course//test.csv"</code></pre>
<pre class="code-output documenter-example-output" id="var-test_data_path">"data//home-data-for-ml-course//test.csv"</pre>

<pre class='language-julia'><code class='language-julia'>test_data = CSV.read(test_data_path, DataFrame)</code></pre>
<table><tbody><tr><th></th><th>Id</th><th>MSSubClass</th><th>MSZoning</th><th>LotFrontage</th><th>LotArea</th><th>Street</th><th>Alley</th><th>LotShape</th><th>...</th></tr><tr><td>1</td><td>1461</td><td>20</td><td>"RH"</td><td>"80"</td><td>11622</td><td>"Pave"</td><td>"NA"</td><td>"Reg"</td><td></td></tr><tr><td>2</td><td>1462</td><td>20</td><td>"RL"</td><td>"81"</td><td>14267</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>3</td><td>1463</td><td>60</td><td>"RL"</td><td>"74"</td><td>13830</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>4</td><td>1464</td><td>60</td><td>"RL"</td><td>"78"</td><td>9978</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>5</td><td>1465</td><td>120</td><td>"RL"</td><td>"43"</td><td>5005</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>6</td><td>1466</td><td>60</td><td>"RL"</td><td>"75"</td><td>10000</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>7</td><td>1467</td><td>20</td><td>"RL"</td><td>"NA"</td><td>7980</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>8</td><td>1468</td><td>60</td><td>"RL"</td><td>"63"</td><td>8402</td><td>"Pave"</td><td>"NA"</td><td>"IR1"</td><td></td></tr><tr><td>9</td><td>1469</td><td>20</td><td>"RL"</td><td>"85"</td><td>10176</td><td>"Pave"</td><td>"NA"</td><td>"Reg"</td><td></td></tr><tr><td>10</td><td>1470</td><td>20</td><td>"RL"</td><td>"70"</td><td>8400</td><td>"Pave"</td><td>"NA"</td><td>"Reg"</td><td></td></tr><tr><td>...</td></tr><tr><td>1459</td><td>2919</td><td>60</td><td>"RL"</td><td>"74"</td><td>9627</td><td>"Pave"</td><td>"NA"</td><td>"Reg"</td><td></td></tr></tbody></table>

<pre class='language-julia'><code class='language-julia'>test_X = test_data[:,feature_names];</code></pre>


<pre class='language-julia'><code class='language-julia'>test_preds = predict(mach, test_X)</code></pre>
<pre class="code-output documenter-example-output" id="var-test_preds">1459-element Vector{Float64}:
 124402.0
 156678.5
 189795.02
 181392.5
 184786.04
 199828.75
 174828.0
      ⋮
  87690.0
  86760.0
  86984.0
 156340.46
 133946.5
 238451.1</pre>

<pre class='language-julia'><code class='language-julia'>output = DataFrame(:ID =&gt; test_data.Id,:SalePrice =&gt; test_preds)</code></pre>
<table><tbody><tr><th></th><th>ID</th><th>SalePrice</th></tr><tr><td>1</td><td>1461</td><td>124402.0</td></tr><tr><td>2</td><td>1462</td><td>1.56678e5</td></tr><tr><td>3</td><td>1463</td><td>189795.0</td></tr><tr><td>4</td><td>1464</td><td>1.81392e5</td></tr><tr><td>5</td><td>1465</td><td>184786.0</td></tr><tr><td>6</td><td>1466</td><td>1.99829e5</td></tr><tr><td>7</td><td>1467</td><td>174828.0</td></tr><tr><td>8</td><td>1468</td><td>1.75705e5</td></tr><tr><td>9</td><td>1469</td><td>1.89534e5</td></tr><tr><td>10</td><td>1470</td><td>1.13977e5</td></tr><tr><td>...</td></tr><tr><td>1459</td><td>2919</td><td>2.38451e5</td></tr></tbody></table>

<pre class='language-julia'><code class='language-julia'>CSV.write("data//home-data-for-ml-course//submissions.csv", output)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash748094">"data//home-data-for-ml-course//submissions.csv"</pre>

<pre class='language-julia'><code class='language-julia'>ŷ = predict(mach, X)</code></pre>
<pre class="code-output documenter-example-output" id="var-ŷ">1460-element Vector{Float64}:
 207936.81
 175583.0
 216197.0
 144564.75
 255722.28
 149060.02
 276293.93
      ⋮
 184721.05
 176207.0
 224053.0
 233962.0
 133793.75
 153000.5</pre>

<pre class='language-julia'><code class='language-julia'>mean_absolute_error(ŷ, y)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash727198">11248.703209589035</pre>
<div class='manifest-versions'>
<p>Built with Julia 1.9.1 and</p>
CSV 0.10.11<br>
DataFrames 1.5.0<br>
MLJ 0.19.2<br>
MLJDecisionTreeInterface 0.4.0
</div>

<!-- PlutoStaticHTML.End -->
~~~