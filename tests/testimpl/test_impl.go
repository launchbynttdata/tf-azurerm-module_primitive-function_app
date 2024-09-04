package testimpl

import (
	"fmt"
	"net/http"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestFunctionApp(t *testing.T, ctx types.TestContext) {
	subscriptionId := os.Getenv("ARM_SUBSCRIPTION_ID")
	if len(subscriptionId) == 0 {
		t.Fatal("ARM_SUBSCRIPTION_ID environment variable is not set")
	}

	functionAppHostname := terraform.Output(t, ctx.TerratestTerraformOptions(), "default_hostname")

	res, err := http.Get(fmt.Sprintf("https://%s", functionAppHostname))
	if err != nil {
		t.Errorf(err.Error())
	}
	t.Log(res)
	assert.Equal(t, 200, res.StatusCode)
}
