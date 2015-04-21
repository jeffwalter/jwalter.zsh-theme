UPDATE_INTERVAL="$((86400 * 7))"

if [ ! -f "${ZSH_CUSTOM}/themes/zsh-jwalter/.lastupdate" ] || ! grep -Eq '^[0-9]+$' "${ZSH_CUSTOM}/themes/zsh-jwalter/.lastupdate"; then
	date +"%s" > "${ZSH_CUSTOM}/themes/zsh-jwalter/.lastupdate"

elif [ "$(($(<"${ZSH_CUSTOM}/themes/zsh-jwalter/.lastupdate") + UPDATE_INTERVAL))" -lt "$(date +"%s")" ]; then
	UPDATE_RESPONSE=""
	while [ -z "${UPDATE_RESPONSE}" ]; do
		echo -n "Would you like to update zsh-jwalter? [y|N] "
		read UPDATE_RESPONSE
		if grep -Eiq '^y(es)?$' <<<"${UPDATE_RESPONSE}"; then
			UPDATE_RESPONSE="y"
		elif grep -Eiq '^no?$' <<<"${UPDATE_RESPONSE}"; then
			UPDATE_RESPONSE="n"
		elif [ -z "${UPDATE_RESPONSE}" ]; then
			UPDATE_RESPONSE="n"
		else
			UPDATE_RESPONSE=""
		fi
	done
	if [ "${UPDATE_RESPONSE}" = "y" ]; then
		pushd "${ZSH_CUSTOM}/themes/zsh-jwalter" &>/dev/null
		git fetch --all
		if [ "$?" != "0" ]; then
			echo "Error: Update failed!"
		else
			git checkout tags/stable
			if [ "$?" != "0" ]; then
				echo "Error: Update failed!"
			else
				date +"%s" > "${ZSH_CUSTOM}/themes/zsh-jwalter/.lastupdate"
			fi
		fi
		popd &>/dev/null
	else
		date +"%s" > "${ZSH_CUSTOM}/themes/zsh-jwalter/.lastupdate"
	fi
fi

source "${ZSH_CUSTOM}/themes/zsh-jwalter/jwalter.lib"
