package kr.co.gotoday.cancel;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RefundReceiveAccountDTO {
    private String bank;
    private String accountNumber;
    private String holderName;
}
