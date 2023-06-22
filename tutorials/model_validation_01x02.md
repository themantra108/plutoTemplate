~~~
<!-- PlutoStaticHTML.Begin -->
<!--
    # This information is used for caching.
    [PlutoStaticHTML.State]
    input_sha = "fd2972283bf5e903b6c2432ede58ed1ce2c8aeaead6ac2596b564adc8b314277"
    julia_version = "1.9.1"
-->
<pre class='language-julia'><code class='language-julia'>using DataFrames, CSV, MLJ, MLJDecisionTreeInterface</code></pre>


<pre class='language-julia'><code class='language-julia'>begin
    iowa_file_path = "data//home-data-for-ml-course//train.csv"
    home_data = CSV.read(iowa_file_path, DataFrame);
    y = home_data.SalePrice;
    feature_names = [:LotArea, :YearBuilt, Symbol("1stFlrSF"), Symbol("2ndFlrSF"), :FullBath, :BedroomAbvGr, :TotRmsAbvGrd];
    X = home_data[:, feature_names];
    
    # Specify Model
    Tree = @load DecisionTreeRegressor pkg=DecisionTree verbosity=0
    iowa_model = Tree()
    mach = machine(iowa_model, X, y, scitype_check_level=0)
    
    # Fit Model
    fit!(mach)
    predictions = predict(mach, X)
    
    println("First in-sample predictions:", predictions[1:5])
    println("Actual target values for those homes:", y[1:5])
    mean_absolute_error(predictions, y)
end</code></pre>
<pre class="code-output documenter-example-output" id="var-iowa_file_path">16686.449680908874</pre>

<pre class='language-julia'><code class='language-julia'>(Xtrain, Xtest), (ytrain, ytest) = partition((X, y), 0.8, rng=123, multi=true);</code></pre>


<pre class='language-julia'><code class='language-julia'>function get_mae(min_samples_leaf, Xtrain, Xtest, ytrain, ytest)
    model = DecisionTreeRegressor(min_samples_leaf = min_samples_leaf, rng=0)
    mach1 = machine(model, Xtrain, ytrain, scitype_check_level=0)
    fit!(mach1)
    preds_val = predict(mach1, Xtest)
    mae = mean_absolute_error(preds_val, ytest)
    return (mae)
end</code></pre>
<pre class="code-output documenter-example-output" id="var-get_mae">get_mae (generic function with 1 method)</pre>

<pre class='language-julia'><code class='language-julia'>#candidate_max_leaf_nodes = [5, 25, 50, 100, 250, 500]
candidate_max_leaf_nodes = [5,6,7,8,9,10]</code></pre>
<pre class="code-output documenter-example-output" id="var-candidate_max_leaf_nodes">6-element Vector{Int64}:
  5
  6
  7
  8
  9
 10</pre>

<pre class='language-julia'><code class='language-julia'>scores = [get_mae(leaf_size, Xtrain, Xtest, ytrain, ytest) =&gt; leaf_size for leaf_size in candidate_max_leaf_nodes]</code></pre>
<pre class="code-output documenter-example-output" id="var-scores">6-element Vector{Pair{Float64, Int64}}:
 26826.471499238956 =&gt; 5
 27065.523599127268 =&gt; 6
 27542.850943833557 =&gt; 7
 28093.636413500884 =&gt; 8
  27197.37198413102 =&gt; 9
 27653.827009645032 =&gt; 10</pre>

<pre class='language-julia'><code class='language-julia'>best_tree_size = (minimum(scores)).second</code></pre>
<pre class="code-output documenter-example-output" id="var-best_tree_size">5</pre>

<pre class='language-julia'><code class='language-julia'>final_model = Tree(min_samples_leaf = best_tree_size, rng = 123)  </code></pre>
<pre class="code-output documenter-example-output" id="var-final_model">DecisionTreeRegressor(
  max_depth = -1, 
  min_samples_leaf = 5, 
  min_samples_split = 2, 
  min_purity_increase = 0.0, 
  n_subfeatures = 0, 
  post_prune = false, 
  merge_purity_threshold = 1.0, 
  feature_importance = :impurity, 
  rng = 123)</pre>

<pre class='language-julia'><code class='language-julia'>final_mach = machine(final_model, X, y, scitype_check_level=0)</code></pre>
<pre class="code-output documenter-example-output" id="var-final_mach">untrained Machine; caches model-specific representations of data
  model: DecisionTreeRegressor(max_depth = -1, …)
  args: 
    1:	Source @086 ⏎ ScientificTypesBase.Table{AbstractVector{ScientificTypesBase.Count}}
    2:	Source @318 ⏎ AbstractVector{ScientificTypesBase.Count}
</pre>

<pre class='language-julia'><code class='language-julia'>fit!(final_mach)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash124191">trained Machine; caches model-specific representations of data
  model: DecisionTreeRegressor(max_depth = -1, …)
  args: 
    1:	Source @086 ⏎ ScientificTypesBase.Table{AbstractVector{ScientificTypesBase.Count}}
    2:	Source @318 ⏎ AbstractVector{ScientificTypesBase.Count}
</pre>

<pre class='language-julia'><code class='language-julia'>ŷ = predict(final_mach, X)</code></pre>
<pre class="code-output documenter-example-output" id="var-ŷ">1460-element Vector{Float64}:
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

<pre class='language-julia'><code class='language-julia'>mean_absolute_error(ŷ, y)</code></pre>
<pre class="code-output documenter-example-output" id="var-hash727198">16686.449680908874</pre>
<div class='manifest-versions'>
<p>Built with Julia 1.9.1 and</p>
CSV 0.10.9<br>
DataFrames 1.5.0<br>
MLJ 0.19.1<br>
MLJDecisionTreeInterface 0.4.0
</div>

<!-- PlutoStaticHTML.End -->
~~~