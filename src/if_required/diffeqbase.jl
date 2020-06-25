const ComponentSol{T,N,C} = DiffEqBase.AbstractODESolution{T,N,C} where C<:AbstractVector{<:ComponentArray}


# Plotting stuff
function DiffEqBase.getsyms(sol::ComponentSol)
    if DiffEqBase.has_syms(sol.prob.f)
        return sol.prob.f.syms
    else
        return plot_labels(sol.u[1])
    end
end


# A little bit of type piracy. Should probably make this a PR to DiffEqBase
DiffEqBase.cleansyms(syms::AbstractArray{<:String}) = DiffEqBase.cleansyms.(syms)
DiffEqBase.cleansyms(syms::String) = syms

# DiffEqBase.interpret_vars(var::AbstractString, sol::ComponentSol, syms) =
#     DiffEqBase.interpret_vars(_to_sol_index(var, syms), sol, syms)
DiffEqBase.interpret_vars(var::Union{AbstractString, Symbol}, sol::ComponentSol, syms) =
    DiffEqBase.interpret_vars(_to_sol_index(var, syms), sol, syms)
# This doesn't work with mixed strings and integers
DiffEqBase.interpret_vars(vars::Tuple{Vararg{<:Union{<:AbstractString, Symbol}}}, sol::ComponentSol, syms) =
    DiffEqBase.interpret_vars(map(var->_to_sol_index(var, syms), vars), sol, syms)
DiffEqBase.interpret_vars(vars::AbstractArray{<:Union{<:AbstractString, Symbol}}, sol::ComponentSol, syms) =
    DiffEqBase.interpret_vars(collect(Iterators.flatten(map(var->_to_sol_index(var, syms), vars))), sol, syms)


_to_sol_index(var::Symbol, syms) = _to_sol_index(string(var), syms)
_to_sol_index(var::AbstractString, syms) = findall(startswith.(syms, var))
_to_sol_index(var, syms) = var
