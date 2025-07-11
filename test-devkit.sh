#!/bin/bash

echo "🔍 Running Dev-Kit Validation..."

function check_tool() {
    TOOL_NAME=$1
    COMMAND=$2

    echo -n "🔧 Checking $TOOL_NAME... "
    if $COMMAND &> /dev/null; then
        echo "✅ OK"
    else
        echo "❌ MISSING or NOT WORKING"
    fi
}

check_tool "AWS CLI" "aws --version"
check_tool "OCI CLI" "oci --version"
check_tool "MongoDB Atlas CLI" "atlas version"
check_tool "kubectl" "kubectl version --client"
check_tool "k9s" "k9s version"
check_tool "jq" "jq --version"
check_tool "curl" "curl --version"
check_tool "terraform" "terraform -version"
check_tool "Node.js" "node -v"
check_tool "npm" "npm -v"
check_tool "Python" "python --version"
check_tool "pip" "pip --version"
check_tool "mongosh" "mongosh --version"
check_tool "psql" "psql --version"
check_tool "mysql" "mysql --version"
check_tool "sqlplus" "sqlplus -v"
check_tool "sqlcmd" "sqlcmd -?"

echo "✅ Validation complete."
