package testimpl

import (
	"fmt"
	"net/http"
	"os"
	"strconv"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/retry"
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

	status := retry.DoWithRetry(t, "Check if the function app is up and running", 6, 10*time.Second, func() (string, error) {
		res, err := http.Get(fmt.Sprintf("https://%s", functionAppHostname))
		return strconv.FormatInt(int64(res.StatusCode), 10), err
	})

	assert.Equal(t, "200", status)
}
