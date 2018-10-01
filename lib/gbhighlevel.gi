InstallMethod( HighLevelGroebnerBasis,
  "compute a complete Groebner Basis",
  [ IsList, IsPathAlgebra ],
  function(els, A)
    local gb, el, el_tip,
          n, i, j, x, y, k, l, r, b, c,
          overlap, remainder;

    if not QPA_InArrowIdeal(els, A) then
      Error("elements do not belong to the arrow ideal of the path algebra");
    fi;

    els := MakeUniform(els);

    gb := [];

    while Length(els) > 0 do
      for el in els do
        el_tip := Tip(el);
        Add(gb, el/TipCoefficient(el_tip));
      od;

      n := Length(gb);
      els := [];

      for i in [1..n] do
        x := TipWalk(gb[i]);
        k := Length(x);

        for j in [1..n] do
          y := TipWalk(gb[j]);
          l := Length(y);

          for r in [Maximum(0, k-l)..k-1] do
            if x{[r+1..k]} = y{[1..k-r]} then
              b := x{[1..r]};
              c := y{[k-r+1..l]};

              overlap := gb[i]*Product(c, One(A)) - Product(b, One(A))*gb[j];
              remainder := RemainderOfDivision(overlap, gb, A);

              if not IsZero(remainder) then
                AddSet(els, remainder);
              fi;
            fi;
          od;
        od;
      od;
    od;

    return gb;
  end
);


InstallMethod( RemainderOfDivision,
  "for a path-algebra element and a list of monic path-algebra elements",
  [ IsElementOfMagmaRingModuloRelations, IsList, IsPathAlgebra ],
  function(y, X, A)
    local r, n, y_tip, y_wtip, divided, i, p, u, v;

    r := Zero(A);
    n := Length(X);

    while not IsZero(y) do
      y_tip := Tip(y);
      y_wtip := TipWalk(y_tip);

      divided := false;

      for i in [1..n] do
        p := LeftmostOccurrence(y_wtip, TipWalk(X[i]));

        if p <> fail then
          u := Product(y_wtip{[1..p[1]-1]}, One(A));
          v := Product(y_wtip{[p[2]+1..Length(y_wtip)]}, One(A));

          y := y - TipCoefficient(y_tip) * u*X[i]*v;

          divided := true;
          break;
        fi;
      od;

      if not divided then
        r := r + y_tip;
        y := y - y_tip;
      fi;
    od;

    return r;
  end
);


InstallMethod( LeftmostOccurrence,
  "find second list as sublist of first list",
  [ IsList, IsList ],
  function(b, c)
    local lb, lc, i;

    lb := Length(b);
    lc := Length(c);

    for i in [1..lb-lc+1] do
      if b{[i..i+lc-1]} = c then
        return [i, i+lc-1];
      fi;
    od;

    return fail;
  end
);
