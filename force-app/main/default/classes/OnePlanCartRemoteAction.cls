global with sharing class OnePlanCartRemoteAction implements Callable {

    global Object call(String action, Map<String, Object> args) {
        Map<String, Object> input = (Map<String, Object>) args.get('input');
        Map<String, Object> output = (Map<String, Object>) args.get('output');
        Map<String, Object> options = (Map<String, Object>) args.get('options');

        if (action == 'createAndPriceCart') {
            return createAndPriceCart(input, output, options);
        }

        throw new AuraHandledException('Unknown action: ' + action);
    }

    global Boolean createAndPriceCart(
        Map<String, Object> input,
        Map<String, Object> output,
        Map<String, Object> options
    ) {
        Map<String, Object> planNode = (Map<String, Object>) input.get('Step_SelectPlan');
        String selectedPlan = planNode != null ? (String) planNode.get('SelectedPlan') : null;

        Map<String, Object> addonNode = (Map<String, Object>) input.get('Step_SelectAddons');
        List<String> addons = new List<String>();

        if (addonNode != null && addonNode.containsKey('SelectedAddons')) {
            Object raw = addonNode.get('SelectedAddons');

            if (raw instanceof String) {
                addons.add((String) raw);
            } else if (raw instanceof List<Object>) {
                for (Object obj : (List<Object>) raw) {
                    addons.add((String) obj);
                }
            }
        }

        output.put('success', true);
        output.put('message', 'Cart processing started');
        output.put('plan', selectedPlan);
        output.put('addons', addons);

        return true;
    }
}