/*
 * Copyright 2019 Maksim Zheravin
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package exchange.core2.core.common.api.binary;

import lombok.Getter;

@Getter
public enum BinaryCommandType {

    ADD_ACCOUNTS(1002),
    ADD_SYMBOLS(1003);

    private final int code;

    BinaryCommandType(int code) {
        this.code = code;
    }

    public static BinaryCommandType of(int code) {

        switch (code) {
            case 1002:
                return ADD_ACCOUNTS;
            case 1003:
                return ADD_SYMBOLS;
            default:
                throw new IllegalArgumentException("unknown BinaryCommandType:" + code);
        }

    }

}
