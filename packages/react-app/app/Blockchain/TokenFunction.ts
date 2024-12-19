import { createPublicClient, createWalletClient, custom } from "viem";
import { celoAlfajores} from "viem/chains";
import {
  tokencUSDAbi,
  tokencUSDContractAddress,
} from "./cUSDToken"
import { contractAddress } from "./CarbonTraceAbi";
import { toast } from "sonner";

//transfer function
export const processCheckout = async ( amount: number ) => {
    if (window.ethereum) {
      const privateClient = createWalletClient({
        chain: celoAlfajores,
        transport: custom(window.ethereum),
      });

      const publicClient = createPublicClient({
        chain: celoAlfajores,
        transport: custom(window.ethereum),
      });

      const [address] = await privateClient.getAddresses();

      try {
        const checkoutTxnHash = await privateClient.writeContract({
          account: address,
          address: tokencUSDContractAddress,
          abi: tokencUSDAbi,
          functionName: "transfer",
          args: [contractAddress, BigInt(amount)],
        });

        const checkoutTxnReceipt = await publicClient.waitForTransactionReceipt(
          {
            hash: checkoutTxnHash,
          }
        );

        if (checkoutTxnReceipt.status == "success") {
          return true;
        }

        return false;
      } catch (error) {
        console.log(error);
        toast("Transaction failed, make sure you have enough balance");
        return false;
      }
    }
    return false;
  };

 
  

 